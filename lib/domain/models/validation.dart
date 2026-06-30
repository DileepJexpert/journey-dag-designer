/// Validation result types (build doc §6, §10 "Validation UX"). Produced by the
/// pure [DagValidator]; rendered by the ValidationPanel and used to gate Submit.
///
/// Client validation MIRRORS the server schema; the server re-validates
/// authoritatively (build doc §1.5). Keep the rule set here in lockstep with the
/// backend validator.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'validation.freezed.dart';

enum ValidationSeverity { error, warning }

/// A stable machine code for each rule, so UI and tests don't match on prose.
enum ValidationCode {
  noStartNode,
  startNodeMissing,
  unreachableNode,
  cycleDetected,
  danglingEdge,
  branchArmDeadEnd,
  branchNoDefault, // §9.5: every branch needs a `default`
  joinOnUnknownPredecessor,
  joinOnNotActualPredecessor,
  missingCompensation,
  waitMissingTimeout, // §9.7: every wait needs timeout + onTimeout
  unknownCapability,
  duplicateNodeId,
  emptyDag,
}

@freezed
class ValidationIssue with _$ValidationIssue {
  const factory ValidationIssue({
    required ValidationCode code,
    required ValidationSeverity severity,
    required String message,

    /// The node the issue is attached to, if any (drives the red ring in UI).
    String? nodeId,
  }) = _ValidationIssue;
}

@freezed
class ValidationResult with _$ValidationResult {
  const ValidationResult._();

  const factory ValidationResult({
    @Default(<ValidationIssue>[]) List<ValidationIssue> issues,
  }) = _ValidationResult;

  List<ValidationIssue> get errors =>
      issues.where((i) => i.severity == ValidationSeverity.error).toList();

  List<ValidationIssue> get warnings =>
      issues.where((i) => i.severity == ValidationSeverity.warning).toList();

  /// Submit is disabled while any error exists (mirrors the server gate).
  bool get isValid => errors.isEmpty;

  Set<String> get invalidNodeIds =>
      {for (final i in errors) if (i.nodeId != null) i.nodeId!};
}
