/// The sealed DAG node union (build doc §5). Three shapes:
///
///  * [TaskNode]     — runs a registered capability; fan-out via [next] (>1 =
///                     parallel), join via [joinOn].
///  * [BranchNode]   — picks exactly one outgoing arm by evaluating [arms] in
///                     order against the run context.
///  * [TerminalNode] — a leaf; emits events and/or runs a terminal [action].
///
/// Sealed so `switch` over a node is exhaustive — adding a node kind becomes a
/// compile error everywhere it must be handled (validator, serializer, canvas,
/// simulation).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'branch_arm.dart';

part 'dag_node.freezed.dart';

@freezed
sealed class DagNode with _$DagNode {
  const DagNode._();

  const factory DagNode.task({
    required String id,

    /// References a registered [Capability.key]. The palette only offers
    /// registered capabilities, so this can only be set to something real.
    required String capabilityKey,

    /// Outgoing edges. Fan-out (parallel successors) = length > 1.
    @Default(<String>[]) List<String> next,

    /// Predecessors this node must wait for before running (join). Empty = run
    /// as soon as any inbound edge delivers.
    @Default(<String>[]) List<String> joinOn,

    /// Backpressure marker, e.g. "finnone_pool".
    String? meter,

    /// Node id to run on failure (saga compensation).
    String? compensation,
    @Default(false) bool optional,
  }) = TaskNode;

  const factory DagNode.branch({
    required String id,
    @Default(<String>[]) List<String> joinOn,
    required List<BranchArm> arms,
  }) = BranchNode;

  const factory DagNode.terminal({
    required String id,
    @Default(<String>[]) List<String> emit,

    /// e.g. "push_decision_to_channel".
    String? action,
  }) = TerminalNode;

  /// The node id, regardless of variant.
  @override
  String get id => switch (this) {
        TaskNode(:final id) => id,
        BranchNode(:final id) => id,
        TerminalNode(:final id) => id,
      };

  /// Predecessors this node joins on, regardless of variant (terminal = none).
  List<String> get joinOn => switch (this) {
        TaskNode(:final joinOn) => joinOn,
        BranchNode(:final joinOn) => joinOn,
        TerminalNode() => const <String>[],
      };

  /// Direct successor node ids, regardless of variant. For a branch this is the
  /// union of all arm targets.
  List<String> get successors => switch (this) {
        TaskNode(:final next) => next,
        BranchNode(:final arms) => arms.map((a) => a.next).toList(),
        TerminalNode() => const <String>[],
      };
}
