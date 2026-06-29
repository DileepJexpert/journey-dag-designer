/// THE single source of DAG config output (build doc §2, §6).
///
/// The canonical config JSON is a **shared contract** between this app's
/// [ConfigSerializer] and the orchestration ENGINE's loader: they must agree
/// byte-for-byte. The engine does not exist yet, so the schema here is
/// **PROVISIONAL** (build doc §5) and lives in exactly one place — change it
/// here and nowhere else.
///
/// We deliberately hand-emit (rather than lean on freezed's union JSON) so the
/// wire shape is fully under our control and matches §5 exactly:
///
/// ```json
/// {
///   "key": "loan-origination",
///   "startNodeId": "n_customer",
///   "nodes": [
///     {"type":"task","id":"n_customer","capabilityKey":"customer-party","next":["n_kyc"]},
///     {"type":"branch","id":"n_decide","arms":[{"expression":"...","next":"n_book"}]},
///     {"type":"terminal","id":"n_done","action":"push_decision_to_channel","emit":["LoanBooked"]}
///   ],
///   "layout": {"n_customer":{"x":80,"y":200}}
/// }
/// ```
///
/// Round-trip invariant: `fromJson(toJson(dag)) == dag`.
library;

import 'dart:convert';

import '../models/branch_arm.dart';
import '../models/dag.dart';
import '../models/dag_node.dart';
import '../models/node_layout.dart';

/// Discriminator values for the `type` field — keep in lockstep with the engine.
class _NodeType {
  static const task = 'task';
  static const branch = 'branch';
  static const terminal = 'terminal';
}

class ConfigSerializer {
  const ConfigSerializer();

  // ---------------------------------------------------------------------------
  // Dag -> JSON (canonical, stored)
  // ---------------------------------------------------------------------------

  /// Canonical config map. [key] is the journey key (the DAG itself does not
  /// carry it). Field/array order here is the contract — do not reorder lightly.
  Map<String, dynamic> toJson(Dag dag, {required String key}) {
    return {
      'key': key,
      'startNodeId': dag.startNodeId,
      'nodes': [for (final n in dag.nodes) _nodeToJson(n)],
      'layout': {
        for (final entry in dag.layout.entries)
          entry.key: {'x': entry.value.x, 'y': entry.value.y},
      },
    };
  }

  /// Pretty-printed canonical JSON (2-space indent) for the config preview.
  String toJsonString(Dag dag, {required String key}) =>
      const JsonEncoder.withIndent('  ').convert(toJson(dag, key: key));

  Map<String, dynamic> _nodeToJson(DagNode node) => switch (node) {
        TaskNode() => {
            'type': _NodeType.task,
            'id': node.id,
            'capabilityKey': node.capabilityKey,
            // Only emit non-empty/non-default fields, matching §5's terse shape.
            if (node.next.isNotEmpty) 'next': node.next,
            if (node.joinOn.isNotEmpty) 'joinOn': node.joinOn,
            if (node.meter != null) 'meter': node.meter,
            if (node.compensation != null) 'compensation': node.compensation,
            if (node.optional) 'optional': true,
          },
        BranchNode() => {
            'type': _NodeType.branch,
            'id': node.id,
            if (node.joinOn.isNotEmpty) 'joinOn': node.joinOn,
            'arms': [
              for (final a in node.arms)
                {'expression': a.expression, 'next': a.next},
            ],
          },
        TerminalNode() => {
            'type': _NodeType.terminal,
            'id': node.id,
            if (node.action != null) 'action': node.action,
            if (node.emit.isNotEmpty) 'emit': node.emit,
          },
      };

  // ---------------------------------------------------------------------------
  // JSON -> Dag (load)
  // ---------------------------------------------------------------------------

  Dag fromJson(Map<String, dynamic> json) {
    final nodes = [
      for (final raw in (json['nodes'] as List? ?? const []))
        _nodeFromJson(raw as Map<String, dynamic>),
    ];
    final layout = <String, NodeLayout>{
      for (final entry in (json['layout'] as Map? ?? const {}).entries)
        entry.key as String: NodeLayout(
          x: (entry.value['x'] as num).toDouble(),
          y: (entry.value['y'] as num).toDouble(),
        ),
    };
    return Dag(
      startNodeId: json['startNodeId'] as String,
      nodes: nodes,
      layout: layout,
    );
  }

  Dag fromJsonString(String source) =>
      fromJson(jsonDecode(source) as Map<String, dynamic>);

  /// The journey key carried alongside the DAG in the canonical config.
  String keyOf(Map<String, dynamic> json) => json['key'] as String;

  DagNode _nodeFromJson(Map<String, dynamic> j) {
    final type = j['type'] as String;
    final id = j['id'] as String;
    switch (type) {
      case _NodeType.task:
        return DagNode.task(
          id: id,
          capabilityKey: j['capabilityKey'] as String,
          next: _stringList(j['next']),
          joinOn: _stringList(j['joinOn']),
          meter: j['meter'] as String?,
          compensation: j['compensation'] as String?,
          optional: j['optional'] as bool? ?? false,
        );
      case _NodeType.branch:
        return DagNode.branch(
          id: id,
          joinOn: _stringList(j['joinOn']),
          arms: [
            for (final a in (j['arms'] as List? ?? const []))
              BranchArm(
                expression: a['expression'] as String,
                next: a['next'] as String,
              ),
          ],
        );
      case _NodeType.terminal:
        return DagNode.terminal(
          id: id,
          action: j['action'] as String?,
          emit: _stringList(j['emit']),
        );
      default:
        throw FormatException('Unknown node type "$type" for node "$id"');
    }
  }

  static List<String> _stringList(dynamic v) =>
      v == null ? const [] : [for (final e in v as List) e as String];
}
