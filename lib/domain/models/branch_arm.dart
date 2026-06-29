/// One labelled arm of a [BranchNode]: a boolean expression evaluated against
/// the run context and the node id to go to when it is the first arm to match
/// (build doc §5).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_arm.freezed.dart';

@freezed
class BranchArm with _$BranchArm {
  const factory BranchArm({
    required String expression,
    required String next,
  }) = _BranchArm;
}
