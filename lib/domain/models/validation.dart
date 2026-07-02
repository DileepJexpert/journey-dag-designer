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
/// The registry's server-side validator emits the SAME names (this vocabulary
/// is part of the §7 seam), plus the parse-level gates below that the designer
/// enforces by construction.
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

  // Server-side parse-level gates (the designer can't author these states, but
  // the registry can report them on hand-edited/imported configs):
  unknownNodeType,
  invalidTerminalStatus,
  unsupportedJoinPolicy,

  /// Fallback for a server code this build doesn't know yet — the issue still
  /// renders (message + nodeId) instead of being dropped. FAIL OPEN on display,
  /// never on submission: the server's 422 gate is what blocks publishing.
  serverRule,
}

/// Lenient wire parse: an unknown server code maps to [ValidationCode.serverRule]
/// so a registry newer than this build never crashes the validation panel.
ValidationCode validationCodeFromWire(String? code) {
  for (final c in ValidationCode.values) {
    if (c.name == code) return c;
  }
  return ValidationCode.serverRule;
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
