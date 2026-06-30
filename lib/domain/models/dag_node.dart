/// The §7 node grammar (Charter §2) as a sealed union — ten node types. Sealed
/// so a `switch` over a node is exhaustive: adding a node kind becomes a compile
/// error everywhere it must be handled (serializer, validator, canvas, sim).
///
/// The SCHEMA is full at T1 (all ten types author/serialize/validate); the
/// ENGINE implements execution tier by tier (§10). `next` is the success edge
/// list; routing nodes (branch/parallel/join/human/foreach) use their own edge
/// fields. Reachability/cycle checks use [successors] (the union of all forward
/// targets); failure/compensation edges are followed separately.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'branch_arm.dart';
import 'node_policies.dart';

part 'dag_node.freezed.dart';

enum JoinPolicy { allOf, anyOf, quorum }

enum ForeachMode { seq, parallel }

enum TerminalStatus { completed, rejected, failed }

@freezed
sealed class DagNode with _$DagNode {
  const DagNode._();

  /// Invoke a capability/adapter operation (Charter §2). The workhorse.
  const factory DagNode.task({
    required String id,
    required String capability,
    String? operation,
    String? input, // expression map -> capability input
    String? output, // context key to write the result into
    @Default(<String>[]) List<String> next,
    String? condition, // run only if true, else skip to next
    String? onFailure, // node id | "compensate" | "dlq" | "fail"
    NodePolicies? policies,
    Compensation? compensation,
    @Default(false) bool optional,
  }) = TaskNode;

  /// Conditional fork — first matching arm wins; `defaultNext` is mandatory.
  const factory DagNode.branch({
    required String id,
    @Default(<BranchArm>[]) List<BranchArm> arms,
    String? defaultNext, // JSON: "default"
    String? condition,
  }) = BranchNode;

  /// Fan out to several branches concurrently; they re-converge at a join.
  const factory DagNode.parallel({
    required String id,
    @Default(<String>[]) List<String> branches,
    String? condition,
  }) = ParallelNode;

  /// Wait for predecessors per [policy] (allOf | anyOf | quorum(n)).
  const factory DagNode.join({
    required String id,
    @Default(<String>[]) List<String> joinOn,
    @Default(JoinPolicy.allOf) JoinPolicy policy,
    int? quorum, // required when policy == quorum
    @Default(<String>[]) List<String> next,
    String? condition,
  }) = JoinNode;

  /// Park until a correlated async event arrives (Charter §5).
  const factory DagNode.wait({
    required String id,
    required String waitFor, // event name
    String? correlation, // expression -> correlation key
    String? timeout, // duration; required by validation
    String? onTimeout, // node id; required by validation
    String? output, // context key for the bound event
    @Default(<String>[]) List<String> next,
    String? condition,
  }) = WaitNode;

  /// Delay or scheduled continuation.
  const factory DagNode.timer({
    required String id,
    String? delay, // duration, e.g. "2h"
    String? at, // cron
    @Default(<String>[]) List<String> next,
    String? condition,
  }) = TimerNode;

  /// Manual task (maker-checker); routes by the operator's chosen outcome.
  const factory DagNode.human({
    required String id,
    String? assignTo, // role
    String? form,
    @Default(<HumanOutcome>[]) List<HumanOutcome> outcomes,
    String? timeout,
    String? condition,
  }) = HumanNode;

  /// Iterate a collection through a body subgraph (bounded).
  const factory DagNode.foreach({
    required String id,
    required String items, // expression -> collection
    @Default(<String>[]) List<String> body, // body subgraph entry node id(s)
    @Default(ForeachMode.seq) ForeachMode mode,
    int? parallelism, // when mode == parallel
    @Default(<String>[]) List<String> next,
    String? condition,
  }) = ForeachNode;

  /// Call another journey (reuse), pinning a version.
  const factory DagNode.subjourney({
    required String id,
    required String journeyKey,
    int? journeyVersion,
    String? input,
    String? output,
    @Default(<String>[]) List<String> next,
    String? condition,
  }) = SubjourneyNode;

  /// End of a path (Charter §2): emits events and a terminal status.
  const factory DagNode.terminal({
    required String id,
    @Default(<String>[]) List<String> emit,
    String? action,
    @Default(TerminalStatus.completed) TerminalStatus status,
  }) = TerminalNode;

  /// The node id, regardless of variant.
  @override
  String get id => switch (this) {
        TaskNode(:final id) => id,
        BranchNode(:final id) => id,
        ParallelNode(:final id) => id,
        JoinNode(:final id) => id,
        WaitNode(:final id) => id,
        TimerNode(:final id) => id,
        HumanNode(:final id) => id,
        ForeachNode(:final id) => id,
        SubjourneyNode(:final id) => id,
        TerminalNode(:final id) => id,
      };

  /// Short type label (matches the §7 `type` discriminator).
  String get typeName => switch (this) {
        TaskNode() => 'task',
        BranchNode() => 'branch',
        ParallelNode() => 'parallel',
        JoinNode() => 'join',
        WaitNode() => 'wait',
        TimerNode() => 'timer',
        HumanNode() => 'human',
        ForeachNode() => 'foreach',
        SubjourneyNode() => 'subjourney',
        TerminalNode() => 'terminal',
      };

  /// `joinOn` predecessors a node waits on (only join nodes have them).
  List<String> get joinOn => switch (this) {
        JoinNode(:final joinOn) => joinOn,
        _ => const <String>[],
      };

  /// Optional `condition` gating a node's execution.
  String? get condition => switch (this) {
        TaskNode(:final condition) => condition,
        BranchNode(:final condition) => condition,
        ParallelNode(:final condition) => condition,
        JoinNode(:final condition) => condition,
        WaitNode(:final condition) => condition,
        TimerNode(:final condition) => condition,
        HumanNode(:final condition) => condition,
        ForeachNode(:final condition) => condition,
        SubjourneyNode(:final condition) => condition,
        TerminalNode() => null,
      };

  /// All forward routing targets, for reachability/cycle/dangling checks.
  /// (Failure `onFailure` and `compensation` edges are followed separately.)
  List<String> get successors => switch (this) {
        TaskNode(:final next) => next,
        BranchNode(:final arms, :final defaultNext) => [
            ...arms.map((a) => a.next),
            if (defaultNext != null) defaultNext,
          ],
        ParallelNode(:final branches) => branches,
        JoinNode(:final next) => next,
        WaitNode(:final next, :final onTimeout) => [
            ...next,
            if (onTimeout != null) onTimeout,
          ],
        TimerNode(:final next) => next,
        HumanNode(:final outcomes) => outcomes.map((o) => o.next).toList(),
        ForeachNode(:final body, :final next) => [...body, ...next],
        SubjourneyNode(:final next) => next,
        TerminalNode() => const <String>[],
      };
}
