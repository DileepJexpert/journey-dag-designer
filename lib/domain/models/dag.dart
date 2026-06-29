/// The authored graph: a start node, the node set, and persisted layout
/// (build doc §5). Pure value type — no canvas, no API. The canvas renders it,
/// the serializer turns it into config, neither owns it.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'dag_node.dart';
import 'node_layout.dart';

part 'dag.freezed.dart';

@freezed
class Dag with _$Dag {
  const Dag._();

  const factory Dag({
    required String startNodeId,
    required List<DagNode> nodes,

    /// nodeId -> persisted canvas position.
    @Default(<String, NodeLayout>{}) Map<String, NodeLayout> layout,
  }) = _Dag;

  /// Index of nodes by id. Throws if the id is unknown — callers that may be
  /// holding a dangling reference should use [nodeOrNull].
  Map<String, DagNode> get byId => {for (final n in nodes) n.id: n};

  DagNode? nodeOrNull(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }
}
