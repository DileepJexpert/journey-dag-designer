/// One labelled arm of a branch node (Charter §2): a boolean `when` expression
/// over `context` and the node id to go to when it is the first arm to match.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_arm.freezed.dart';

@freezed
class BranchArm with _$BranchArm {
  const factory BranchArm({
    /// Expression over `context`, e.g. `context.decision.approved == true`.
    required String when,
    required String next,
  }) = _BranchArm;
}

/// One outcome of a human (maker-checker) node (Charter §2): a discrete decision
/// value and where the journey goes when the operator picks it.
@freezed
class HumanOutcome with _$HumanOutcome {
  const factory HumanOutcome({
    required String value,
    required String next,
  }) = _HumanOutcome;
}
