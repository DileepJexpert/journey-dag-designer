/// Pure graph validation (Charter §9). Mirrors the engine's publish-time check;
/// the engine re-validates authoritatively. The [ValidationCode]s are the shared
/// vocabulary. Rules:
///  1. non-empty DAG; `startNodeId` resolves; unique ids.
///  2. every node reachable from the start.
///  3. acyclic — EXCEPT time-gated loops through `wait`/`timer` (Charter §5 chase
///     pattern); business iteration is via bounded `foreach`.
///  4. no dangling edges (every successor / `onFailure` node-id target exists).
///  5. every path reaches a `terminal`.
///  6. every `branch` declares a `default` (total coverage, §9.5).
///  7. every `join.joinOn` references real, actual predecessors.
///  8. any node with a `meter` policy OR a money/booking capability MUST declare
///     `compensation` (saga safety, §9.6).
///  9. every `wait` declares `timeout` + `onTimeout` (§9.7).
/// 10. every task `capability` exists in the registry (§9.8).
library;

import '../models/capability.dart';
import '../models/dag.dart';
import '../models/dag_node.dart';
import '../models/validation.dart';

class DagValidator {
  const DagValidator();

  static const _failureKeywords = {'compensate', 'dlq', 'fail'};

  ValidationResult validate(Dag dag, {required List<Capability> capabilities}) {
    final issues = <ValidationIssue>[];
    final capByKey = {for (final c in capabilities) c.key: c};

    if (dag.nodes.isEmpty) {
      return const ValidationResult(issues: [
        ValidationIssue(
          code: ValidationCode.emptyDag,
          severity: ValidationSeverity.error,
          message: 'The journey has no nodes.',
        ),
      ]);
    }

    final byId = dag.byId;

    // Unique ids.
    final seen = <String>{};
    for (final n in dag.nodes) {
      if (!seen.add(n.id)) {
        issues.add(ValidationIssue(
          code: ValidationCode.duplicateNodeId,
          severity: ValidationSeverity.error,
          message: 'Duplicate node id "${n.id}".',
          nodeId: n.id,
        ));
      }
    }

    // Start node resolves.
    if (!byId.containsKey(dag.startNodeId)) {
      issues.add(ValidationIssue(
        code: ValidationCode.startNodeMissing,
        severity: ValidationSeverity.error,
        message: 'Start node "${dag.startNodeId}" does not exist.',
      ));
    }

    // Dangling edges (forward successors + onFailure node-id targets).
    for (final n in dag.nodes) {
      for (final target in n.successors) {
        if (!byId.containsKey(target)) {
          issues.add(ValidationIssue(
            code: ValidationCode.danglingEdge,
            severity: ValidationSeverity.error,
            message: 'Node "${n.id}" points at missing node "$target".',
            nodeId: n.id,
          ));
        }
      }
      if (n is TaskNode &&
          n.onFailure != null &&
          !_failureKeywords.contains(n.onFailure) &&
          !byId.containsKey(n.onFailure)) {
        issues.add(ValidationIssue(
          code: ValidationCode.danglingEdge,
          severity: ValidationSeverity.error,
          message:
              'Node "${n.id}" onFailure routes to missing node "${n.onFailure}".',
          nodeId: n.id,
        ));
      }
    }

    // Predecessor map over existing forward edges.
    final predecessors = <String, Set<String>>{
      for (final n in dag.nodes) n.id: <String>{},
    };
    for (final n in dag.nodes) {
      for (final target in n.successors) {
        if (byId.containsKey(target)) predecessors[target]!.add(n.id);
      }
    }

    // Branch must have a default (total coverage).
    for (final n in dag.nodes) {
      if (n is BranchNode && (n.defaultNext == null || n.defaultNext!.isEmpty)) {
        issues.add(ValidationIssue(
          code: ValidationCode.branchNoDefault,
          severity: ValidationSeverity.error,
          message: 'Branch "${n.id}" must declare a default arm.',
          nodeId: n.id,
        ));
      }
    }

    // join.joinOn must be real, actual predecessors.
    for (final n in dag.nodes) {
      if (n is! JoinNode) continue;
      for (final dep in n.joinOn) {
        if (!byId.containsKey(dep)) {
          issues.add(ValidationIssue(
            code: ValidationCode.joinOnUnknownPredecessor,
            severity: ValidationSeverity.error,
            message: 'Join "${n.id}" joins on unknown node "$dep".',
            nodeId: n.id,
          ));
        } else if (!predecessors[n.id]!.contains(dep)) {
          issues.add(ValidationIssue(
            code: ValidationCode.joinOnNotActualPredecessor,
            severity: ValidationSeverity.error,
            message:
                'Join "${n.id}" joins on "$dep", which is not one of its predecessors.',
            nodeId: n.id,
          ));
        }
      }
    }

    // Saga safety: meter or money/booking => compensation required.
    for (final n in dag.nodes) {
      if (n is! TaskNode) continue;
      final cap = capByKey[n.capability];
      final metered = n.policies?.meter != null;
      final money = cap?.isMoneyOrBookingNode ?? false;
      if ((metered || money) && n.compensation == null) {
        issues.add(ValidationIssue(
          code: ValidationCode.missingCompensation,
          severity: ValidationSeverity.error,
          message:
              'Node "${n.id}" is a money/booking or metered step and must declare a compensation.',
          nodeId: n.id,
        ));
      }
    }

    // wait needs timeout + onTimeout.
    for (final n in dag.nodes) {
      if (n is! WaitNode) continue;
      if (n.timeout == null || n.onTimeout == null) {
        issues.add(ValidationIssue(
          code: ValidationCode.waitMissingTimeout,
          severity: ValidationSeverity.error,
          message: 'Wait "${n.id}" must declare both timeout and onTimeout.',
          nodeId: n.id,
        ));
      }
    }

    // Capability registry.
    for (final n in dag.nodes) {
      if (n is TaskNode && !capByKey.containsKey(n.capability)) {
        issues.add(ValidationIssue(
          code: ValidationCode.unknownCapability,
          severity: ValidationSeverity.error,
          message:
              'Node "${n.id}" references unregistered capability "${n.capability}".',
          nodeId: n.id,
        ));
      }
    }

    // Reachability + acyclicity (only meaningful if start exists).
    if (byId.containsKey(dag.startNodeId)) {
      final reachable = _reachableFrom(dag.startNodeId, byId);
      for (final n in dag.nodes) {
        if (!reachable.contains(n.id)) {
          issues.add(ValidationIssue(
            code: ValidationCode.unreachableNode,
            severity: ValidationSeverity.error,
            message: 'Node "${n.id}" is not reachable from the start node.',
            nodeId: n.id,
          ));
        }
      }

      final cycleNode = _firstComputeCycle(dag.startNodeId, byId);
      if (cycleNode != null) {
        issues.add(ValidationIssue(
          code: ValidationCode.cycleDetected,
          severity: ValidationSeverity.error,
          message:
              'Cycle detected at "$cycleNode" (only time-gated wait/timer loops or bounded foreach may repeat).',
          nodeId: cycleNode,
        ));
      }

      for (final n in dag.nodes) {
        if (n is TerminalNode) continue;
        if (!reachable.contains(n.id)) continue;
        if (!_reachesTerminal(n.id, byId, {})) {
          issues.add(ValidationIssue(
            code: ValidationCode.branchArmDeadEnd,
            severity: ValidationSeverity.error,
            message: 'Node "${n.id}" has a path that never reaches a terminal.',
            nodeId: n.id,
          ));
        }
      }
    }

    return ValidationResult(issues: issues);
  }

  Set<String> _reachableFrom(String start, Map<String, DagNode> byId) {
    final visited = <String>{};
    final stack = <String>[start];
    while (stack.isNotEmpty) {
      final id = stack.removeLast();
      if (!visited.add(id)) continue;
      final node = byId[id];
      if (node == null) continue;
      for (final s in node.successors) {
        if (byId.containsKey(s)) stack.add(s);
      }
      // Failure / compensation edges keep their targets reachable too.
      if (node is TaskNode &&
          node.onFailure != null &&
          !_failureKeywords.contains(node.onFailure) &&
          byId.containsKey(node.onFailure)) {
        stack.add(node.onFailure!);
      }
    }
    return visited;
  }

  /// Back-edge detection that ignores edges INTO a `wait`/`timer` node — those
  /// model time-gated chase loops (Charter §5), not forbidden compute cycles.
  String? _firstComputeCycle(String start, Map<String, DagNode> byId) {
    final state = <String, int>{}; // 0=visiting, 1=done
    String? found;

    void visit(String id) {
      if (found != null) return;
      state[id] = 0;
      final node = byId[id];
      if (node != null) {
        for (final s in node.successors) {
          final target = byId[s];
          if (target == null) continue;
          if (target is WaitNode || target is TimerNode) continue; // time-gated
          final st = state[s];
          if (st == 0) {
            found = s;
            return;
          } else if (st == null) {
            visit(s);
            if (found != null) return;
          }
        }
      }
      state[id] = 1;
    }

    visit(start);
    return found;
  }

  bool _reachesTerminal(
      String id, Map<String, DagNode> byId, Set<String> onPath) {
    final node = byId[id];
    if (node == null) return false;
    if (node is TerminalNode) return true;
    if (!onPath.add(id)) return false; // avoid infinite recursion on loops
    final result = node.successors
        .any((s) => byId.containsKey(s) && _reachesTerminal(s, byId, onPath));
    onPath.remove(id);
    return result;
  }
}
