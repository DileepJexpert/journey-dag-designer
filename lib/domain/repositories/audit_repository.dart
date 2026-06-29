/// Abstract audit repository (build doc §8, §9). Read-only governance trail.
library;

import '../models/audit_entry.dart';

abstract interface class AuditRepository {
  Future<List<AuditEntry>> listAudit({required String journeyId});
}
