/// Pure structural diff of two DAGs (build doc §6). Drives the version-diff view
/// (added = green, removed = red, changed = amber). Layout (canvas position) is
/// NOT a semantic change and is ignored — only config differences count.
library;

import 'package:dag_core/dag_core.dart';
import '../models/journey_diff.dart';

class DagDiffService {
  const DagDiffService();

  DagDiff compute(Dag oldDag, Dag newDag) {
    final oldById = oldDag.byId;
    final newById = newDag.byId;
    final oldIds = oldById.keys.toSet();
    final newIds = newById.keys.toSet();

    final added = newIds.difference(oldIds).toList()..sort();
    final removed = oldIds.difference(newIds).toList()..sort();

    final changed = <String>[];
    for (final id in oldIds.intersection(newIds)) {
      // freezed value-equality: ignores layout (not part of DagNode), so this is
      // a pure config comparison.
      if (oldById[id] != newById[id]) changed.add(id);
    }
    changed.sort();

    final oldEdges = _edges(oldDag);
    final newEdges = _edges(newDag);
    final addedEdges = newEdges.difference(oldEdges).map(_toEdge).toList()
      ..sort(_edgeCompare);
    final removedEdges = oldEdges.difference(newEdges).map(_toEdge).toList()
      ..sort(_edgeCompare);

    return DagDiff(
      addedNodes: added,
      removedNodes: removed,
      changedNodes: changed,
      addedEdges: addedEdges,
      removedEdges: removedEdges,
    );
  }

  Set<String> _edges(Dag dag) {
    final out = <String>{};
    for (final n in dag.nodes) {
      for (final s in n.successors) {
        out.add('${n.id}\u0000$s');
      }
    }
    return out;
  }

  DagEdge _toEdge(String packed) {
    final parts = packed.split('\u0000');
    return DagEdge(from: parts[0], to: parts[1]);
  }

  int _edgeCompare(DagEdge a, DagEdge b) {
    final f = a.from.compareTo(b.from);
    return f != 0 ? f : a.to.compareTo(b.to);
  }
}
