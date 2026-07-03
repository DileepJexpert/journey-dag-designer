/// One row of the read-only audit trail (build doc §8 audit). Governance
/// evidence: who did what to which journey/version and when.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_entry.freezed.dart';

enum AuditAction {
  created,
  draftSaved,
  submittedForApproval,
  approved,
  published,
  rejected,
  cloned,
  bound,
}

@freezed
class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    required String id,
    required String journeyId,
    int? version,
    required AuditAction action,
    required String actorId,
    required DateTime at,
    String? note,
  }) = _AuditEntry;
}
