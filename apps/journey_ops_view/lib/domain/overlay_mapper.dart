/// Maps a run's transition history onto its pinned graph (spec C.2): every
/// node gets exactly one of FOUR render states — completed / active / failed /
/// notReached. There is deliberately NO "pending": a node that never ran is
/// "not reached" (a statement about this run's history), not "pending" (a
/// promise about its future the view cannot make).
library;

import 'package:dag_core/dag_core.dart';

import 'models.dart';

enum NodeRunState {
  completed,
  active,

  /// Wait/timer/human nodes active WITHIN the run budget are working as
  /// designed — labelled "waiting (by design)" so nobody triages them as
  /// stuck. Renders in the active family.
  waitingByDesign,
  failed,
  notReached,
}

class RunOverlayResult {
  const RunOverlayResult({required this.states, required this.orphanNodeIds});

  /// Render state for every node in the graph (keyed by nodeId).
  final Map<String, NodeRunState> states;

  /// Transition nodeIds NOT present in the rendered graph (D: a legacy /
  /// approximate graph, or drift) — shown as warn chips, never dropped.
  final List<String> orphanNodeIds;
}

/// Pure mapping from (graph, run) to per-node render states.
///
/// Rules, in order per node:
///  1. any FAILED transition            -> failed
///  2. any COMPLETED transition         -> completed
///  3. DISPATCHED only + run RUNNING    -> active (waitingByDesign for
///     wait/timer/human node kinds — within budget they wait BY DESIGN)
///  4. DISPATCHED only + run TERMINAL   -> notReached ("terminal freezes
///     notReached": nothing on an ended run may render as live work)
///  5. no transition                    -> notReached
RunOverlayResult mapRunOntoGraph(Dag graph, RunDetail run) {
  final byNode = <String, List<TransitionEntry>>{};
  for (final t in run.transitions) {
    byNode.putIfAbsent(t.nodeId, () => []).add(t);
  }

  final states = <String, NodeRunState>{};
  for (final node in graph.nodes) {
    final ts = byNode[node.id];
    if (ts == null || ts.isEmpty) {
      states[node.id] = NodeRunState.notReached;
      continue;
    }
    if (ts.any((t) => t.status == 'FAILED')) {
      states[node.id] = NodeRunState.failed;
    } else if (ts.any((t) => t.status == 'COMPLETED')) {
      states[node.id] = NodeRunState.completed;
    } else if (!run.isTerminal) {
      states[node.id] = _isWaitingKind(graph.nodeOrNull(node.id))
          ? NodeRunState.waitingByDesign
          : NodeRunState.active;
    } else {
      states[node.id] = NodeRunState.notReached;
    }
  }

  final graphIds = graph.nodes.map((n) => n.id).toSet();
  final orphans = <String>[];
  for (final t in run.transitions) {
    if (!graphIds.contains(t.nodeId) && !orphans.contains(t.nodeId)) {
      orphans.add(t.nodeId);
    }
  }
  return RunOverlayResult(states: states, orphanNodeIds: orphans);
}

bool _isWaitingKind(DagNode? node) => switch (node) {
      WaitNode() || TimerNode() || HumanNode() => true,
      _ => false,
    };
