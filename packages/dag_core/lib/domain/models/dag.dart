/// The authored graph plus its journey-level §7 config (Charter §7): the start
/// node, the node set, the named backpressure `pools`, and the typed `context`
/// schema reference. Pure value type — the canvas renders it, the serializer
/// turns it into the §7 JSON, neither owns it. `layout` (canvas positions) is a
/// Designer-only concern carried alongside; the engine ignores it.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'dag_node.dart';
import 'node_layout.dart';
import 'node_policies.dart';

part 'dag.freezed.dart';

@freezed
class Dag with _$Dag {
  const Dag._();

  const factory Dag({
    required String startNodeId,
    required List<DagNode> nodes,

    /// Named backpressure pools (Charter §7 `pools`): pool name -> cap.
    @Default(<String, PoolSpec>{}) Map<String, PoolSpec> pools,

    /// The typed context schema reference, e.g. "loan-origination-context@1".
    String? contextSchemaRef,

    /// nodeId -> persisted canvas position (Designer-only, not engine config).
    @Default(<String, NodeLayout>{}) Map<String, NodeLayout> layout,
  }) = _Dag;

  /// Index of nodes by id.
  Map<String, DagNode> get byId => {for (final n in nodes) n.id: n};

  DagNode? nodeOrNull(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }
}
