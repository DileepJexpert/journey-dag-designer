/// Structural diff between two DAGs (build doc §6 DagDiffService, §8 versions).
/// Drives the version-diff view: added = green, removed = red, changed = amber.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_diff.freezed.dart';

/// A directed edge between two node ids (used to report edge-level changes).
@freezed
class DagEdge with _$DagEdge {
  const factory DagEdge({required String from, required String to}) = _DagEdge;
}

@freezed
class DagDiff with _$DagDiff {
  const DagDiff._();

  const factory DagDiff({
    @Default(<String>[]) List<String> addedNodes,
    @Default(<String>[]) List<String> removedNodes,

    /// Nodes present in both DAGs whose definition changed (config, not layout).
    @Default(<String>[]) List<String> changedNodes,
    @Default(<DagEdge>[]) List<DagEdge> addedEdges,
    @Default(<DagEdge>[]) List<DagEdge> removedEdges,
  }) = _DagDiff;

  bool get isEmpty =>
      addedNodes.isEmpty &&
      removedNodes.isEmpty &&
      changedNodes.isEmpty &&
      addedEdges.isEmpty &&
      removedEdges.isEmpty;
}
