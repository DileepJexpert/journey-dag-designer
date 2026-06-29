/// Pure, deterministic simulation planner (build doc §6, §1.7).
///
/// PREVIEW ONLY. It models ORDER and STRUCTURE — which nodes fire, in what
/// parallel groups, down which branch, and (on an injected failure) which
/// compensation path runs. It does NOT model real capability behavior, real
/// timing, or real failures, and must never become a second execution engine.
/// The real orchestration engine (backend) is authoritative.
///
/// A run is a list of [RunStep]s; each step is the set of nodes that become
/// ready simultaneously (a parallel group). A node is ready when it has been
/// reached by an active edge AND all of its `joinOn` predecessors have fired.
library;

import '../models/dag.dart';
import '../models/dag_node.dart';
import '../models/run_step.dart';

/// Inputs to a simulated run, supplied by the simulation input form.
class SimulationInput {
  const SimulationInput({
    this.branchChoices = const {},
    this.failAt,
  });

  /// branchNodeId -> the chosen outgoing node id. When a branch has no entry
  /// here, the first arm is taken (deterministic default for preview).
  final Map<String, String> branchChoices;

  /// Optional node id at which to inject a failure, to preview the saga
  /// compensation path. The node still fires; instead of its normal successors,
  /// its compensation chain is recorded.
  final String? failAt;
}

class SimulationEngine {
  const SimulationEngine();

  SimulationPlan plan(Dag dag, [SimulationInput input = const SimulationInput()]) {
    final byId = dag.byId;
    if (!byId.containsKey(dag.startNodeId)) {
      return const SimulationPlan();
    }

    // Stable node ordering for deterministic parallel-group contents.
    final order = {
      for (var i = 0; i < dag.nodes.length; i++) dag.nodes[i].id: i,
    };

    final fired = <String>{};
    final reached = <String>{dag.startNodeId};
    final steps = <RunStep>[];
    final compensated = <String>[];
    var failed = false;

    var stepIndex = 0;
    while (true) {
      final ready = <DagNode>[];
      for (final n in dag.nodes) {
        if (fired.contains(n.id)) continue;
        if (!reached.contains(n.id)) continue;
        if (n.joinOn.any((j) => !fired.contains(j))) continue;
        ready.add(n);
      }
      if (ready.isEmpty) break;
      ready.sort((a, b) => order[a.id]!.compareTo(order[b.id]!));

      var stepHasMeter = false;
      for (final n in ready) {
        fired.add(n.id);
        if (n is TaskNode && n.meter != null) stepHasMeter = true;

        // Inject failure: record compensation chain, halt this node's forward edges.
        if (!failed && input.failAt != null && n.id == input.failAt) {
          failed = true;
          if (n is TaskNode && n.compensation != null) {
            _collectCompensation(n.compensation!, byId, compensated);
          }
          continue;
        }

        for (final s in _activeSuccessors(n, input, byId)) {
          if (byId.containsKey(s)) reached.add(s);
        }
      }

      steps.add(RunStep(
        order: stepIndex++,
        nodeIds: [for (final n in ready) n.id],
        hasMeter: stepHasMeter,
      ));
    }

    return SimulationPlan(steps: steps, compensated: compensated);
  }

  /// The edges that actually carry the token out of [node] given the run input.
  List<String> _activeSuccessors(
      DagNode node, SimulationInput input, Map<String, DagNode> byId) {
    return switch (node) {
      TaskNode(:final next) => next,
      BranchNode(:final id, :final arms) => () {
          if (arms.isEmpty) return const <String>[];
          final chosen = input.branchChoices[id];
          if (chosen != null && arms.any((a) => a.next == chosen)) {
            return <String>[chosen];
          }
          return <String>[arms.first.next];
        }(),
      TerminalNode() => const <String>[],
    };
  }

  /// Walk a compensation chain to its terminal, recording each node once.
  void _collectCompensation(
      String start, Map<String, DagNode> byId, List<String> out) {
    final visited = <String>{};
    var current = start;
    while (byId.containsKey(current) && visited.add(current)) {
      out.add(current);
      final node = byId[current]!;
      final succ = switch (node) {
        TaskNode(:final compensation, :final next) =>
          compensation ?? (next.isNotEmpty ? next.first : null),
        BranchNode(:final arms) => arms.isNotEmpty ? arms.first.next : null,
        TerminalNode() => null,
      };
      if (succ == null) break;
      current = succ;
    }
  }
}
