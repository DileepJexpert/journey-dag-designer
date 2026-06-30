/// Pure graph validation (build doc §6). Mirrors the server schema; the server
/// re-validates authoritatively (build doc §1.5). Keep every rule here in
/// lockstep with the backend validator — the codes in [ValidationCode] are the
/// shared vocabulary.
///
/// Rules:
///  1. non-empty DAG; [Dag.startNodeId] resolves to a real node.
///  2. unique node ids.
///  3. every node reachable from the start node.
///  4. acyclic (DFS back-edge detection).
///  5. every edge target exists (no dangling edges).
///  6. every branch arm eventually reaches a terminal node.
///  7. `joinOn` references real nodes that are ACTUAL predecessors of the node.
///  8. any node with a `meter` OR a money/booking capability MUST define
///     `compensation`.
///  9. every `capabilityKey` exists in the supplied capability registry.
library;

import '../models/capability.dart';
import '../models/dag.dart';
import '../models/dag_node.dart';
import '../models/validation.dart';

class DagValidator {
  const DagValidator();

  /// [capabilities] is the registered palette (keyed by [Capability.key]); a
  /// task referencing a key not present is an error (rule 9). When validating
  /// without a registry (e.g. a structural-only check) pass an empty list and
  /// rule 9 simply reports every task as unknown — callers should pass the real
  /// registry.
  ValidationResult validate(Dag dag, {required List<Capability> capabilities}) {
    final issues = <ValidationIssue>[];
    final capByKey = {for (final c in capabilities) c.key: c};

    if (dag.nodes.isEmpty) {
      issues.add(const ValidationIssue(
        code: ValidationCode.emptyDag,
        severity: ValidationSeverity.error,
        message: 'The journey has no nodes.',
      ));
      return ValidationResult(issues: issues);
    }

    // Rule 2: unique ids.
    final seen = <String>{};
    final duplicates = <String>{};
    for (final n in dag.nodes) {
      if (!seen.add(n.id)) duplicates.add(n.id);
    }
    for (final id in duplicates) {
      issues.add(ValidationIssue(
        code: ValidationCode.duplicateNodeId,
        severity: ValidationSeverity.error,
        message: 'Duplicate node id "$id".',
        nodeId: id,
      ));
    }

    final byId = dag.byId;

    // Rule 1: start node resolves.
    if (!byId.containsKey(dag.startNodeId)) {
      issues.add(ValidationIssue(
        code: ValidationCode.startNodeMissing,
        severity: ValidationSeverity.error,
        message: 'Start node "${dag.startNodeId}" does not exist.',
      ));
    }

    // Rule 5: dangling edges (targets that don't exist).
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
      // A declared compensation must resolve to a real node — otherwise the
      // engine has nothing to run on failure (the saga edge is dangling).
      if (n is TaskNode &&
          n.compensation != null &&
          !byId.containsKey(n.compensation)) {
        issues.add(ValidationIssue(
          code: ValidationCode.danglingEdge,
          severity: ValidationSeverity.error,
          message:
              'Node "${n.id}" declares compensation "${n.compensation}", which does not exist.',
          nodeId: n.id,
        ));
      }
    }

    // Predecessor map (only over edges whose endpoints both exist).
    final predecessors = <String, Set<String>>{
      for (final n in dag.nodes) n.id: <String>{},
    };
    for (final n in dag.nodes) {
      for (final target in n.successors) {
        if (byId.containsKey(target)) predecessors[target]!.add(n.id);
      }
    }

    // Rule 7: joinOn must reference actual predecessors.
    for (final n in dag.nodes) {
      for (final dep in n.joinOn) {
        if (!byId.containsKey(dep)) {
          issues.add(ValidationIssue(
            code: ValidationCode.joinOnUnknownPredecessor,
            severity: ValidationSeverity.error,
            message: 'Node "${n.id}" joins on unknown node "$dep".',
            nodeId: n.id,
          ));
        } else if (!predecessors[n.id]!.contains(dep)) {
          issues.add(ValidationIssue(
            code: ValidationCode.joinOnNotActualPredecessor,
            severity: ValidationSeverity.error,
            message:
                'Node "${n.id}" joins on "$dep", which is not one of its predecessors.',
            nodeId: n.id,
          ));
        }
      }
    }

    // Rule 8: money/booking or metered nodes need compensation.
    for (final n in dag.nodes) {
      if (n is TaskNode) {
        final cap = capByKey[n.capabilityKey];
        final needsCompensation =
            n.meter != null || (cap?.isMoneyOrBookingNode ?? false);
        if (needsCompensation && n.compensation == null) {
          issues.add(ValidationIssue(
            code: ValidationCode.missingCompensation,
            severity: ValidationSeverity.error,
            message:
                'Node "${n.id}" is a money/booking or metered step and must define a compensation.',
            nodeId: n.id,
          ));
        }
      }
    }

    // Rule 9: capability keys exist.
    for (final n in dag.nodes) {
      if (n is TaskNode && !capByKey.containsKey(n.capabilityKey)) {
        issues.add(ValidationIssue(
          code: ValidationCode.unknownCapability,
          severity: ValidationSeverity.error,
          message:
              'Node "${n.id}" references unregistered capability "${n.capabilityKey}".',
          nodeId: n.id,
        ));
      }
    }

    // Reachability + acyclicity only make sense if the start node exists.
    if (byId.containsKey(dag.startNodeId)) {
      final reachable = _reachableFrom(dag.startNodeId, byId);

      // Rule 3: every node reachable.
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

      // Rule 4: acyclic (DFS back-edge).
      final cycleNode = _firstBackEdgeNode(dag.startNodeId, byId);
      if (cycleNode != null) {
        issues.add(ValidationIssue(
          code: ValidationCode.cycleDetected,
          severity: ValidationSeverity.error,
          message: 'The graph contains a cycle (at node "$cycleNode").',
          nodeId: cycleNode,
        ));
      }

      // Rule 6: every branch arm reaches a terminal (only meaningful when acyclic).
      if (cycleNode == null) {
        for (final n in dag.nodes) {
          if (n is BranchNode) {
            for (final arm in n.arms) {
              if (byId.containsKey(arm.next) &&
                  !_reachesTerminal(arm.next, byId)) {
                issues.add(ValidationIssue(
                  code: ValidationCode.branchArmDeadEnd,
                  severity: ValidationSeverity.error,
                  message:
                      'Branch "${n.id}" arm "${arm.expression}" never reaches a terminal node.',
                  nodeId: n.id,
                ));
              }
            }
          }
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
      // A compensation node is reachable via the saga edge, so it is NOT
      // unreachable just because no `next`/arm points at it.
      if (node is TaskNode &&
          node.compensation != null &&
          byId.containsKey(node.compensation)) {
        stack.add(node.compensation!);
      }
    }
    return visited;
  }

  /// Returns the node at which a back-edge (cycle) is first found, or null.
  String? _firstBackEdgeNode(String start, Map<String, DagNode> byId) {
    final state = <String, int>{}; // 0=visiting, 1=done
    String? found;

    void visit(String id) {
      if (found != null) return;
      state[id] = 0;
      final node = byId[id];
      if (node != null) {
        for (final s in node.successors) {
          if (!byId.containsKey(s)) continue;
          final st = state[s];
          if (st == 0) {
            found = s; // back-edge into a node still on the stack
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

  /// Assumes acyclicity. True if some path from [id] ends at a terminal node.
  bool _reachesTerminal(String id, Map<String, DagNode> byId) {
    final node = byId[id];
    if (node == null) return false;
    if (node is TerminalNode) return true;
    for (final s in node.successors) {
      if (byId.containsKey(s) && _reachesTerminal(s, byId)) return true;
    }
    return false;
  }
}
