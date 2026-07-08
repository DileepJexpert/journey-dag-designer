/// Seeded in-memory sync-audit API so the console (and its widget tests) runs
/// with NO backend. Fixtures cover the corner cases the tab must render: an IMPS
/// success WITH a transactionId, an idempotent replay (deduped), a business
/// decline (teal, not red), a technical AMBIGUOUS timeout, an LMS offer AND a
/// no-offer (both SUCCESS — a query that returned "none" is not a failure), and a
/// fail-closed unknown requestCode.
library;

import 'dart:math' as math;

import '../domain/sync_invocation.dart';
import 'sync_ops_api.dart';

class MockSyncOpsApi implements SyncOpsApi {
  MockSyncOpsApi({DateTime? now}) : _now = now ?? DateTime.now().toUtc() {
    _records = _seed(_now);
  }

  final DateTime _now;
  late final List<SyncInvocation> _records;

  static List<SyncInvocation> _seed(DateTime now) {
    DateTime at(int minutesAgo) => now.subtract(Duration(minutes: minutesAgo));
    return [
      SyncInvocation(
        invocationId: 'sync-imps-1', capability: 'imps-disbursal',
        operation: 'transfer', outcome: SyncOutcome.success, startedAt: at(2),
        durationMs: 812, deduped: false, source: 'INDMONEY',
        idempotencyKey: 'idem-imps-1', correlationId: 'c-imps-1',
        transactionId: '003712585052',
      ),
      SyncInvocation(
        invocationId: 'sync-imps-1b', capability: 'imps-disbursal',
        operation: 'transfer', outcome: SyncOutcome.success, startedAt: at(2),
        durationMs: 4, deduped: true, source: 'INDMONEY',
        idempotencyKey: 'idem-imps-1', correlationId: 'c-imps-1',
        transactionId: '003712585052',
      ),
      SyncInvocation(
        invocationId: 'sync-imps-2', capability: 'imps-disbursal',
        operation: 'transfer', outcome: SyncOutcome.businessFailure,
        startedAt: at(5), durationMs: 640, deduped: false, source: 'INDMONEY',
        idempotencyKey: 'idem-imps-2', correlationId: 'c-imps-2',
      ),
      SyncInvocation(
        invocationId: 'sync-imps-3', capability: 'imps-disbursal',
        operation: 'transfer', outcome: SyncOutcome.technicalError,
        startedAt: at(9), durationMs: 10014, deduped: false, source: 'INDMONEY',
        idempotencyKey: 'idem-imps-3', correlationId: 'c-imps-3',
        errorClass: 'AMBIGUOUS', errorCode: 'READ_TIMEOUT',
      ),
      SyncInvocation(
        invocationId: 'sync-lms-1', capability: 'lms-utilities',
        operation: 'OFFER_CHECK', outcome: SyncOutcome.success, startedAt: at(3),
        durationMs: 120, deduped: false, source: 'SAVEIN', correlationId: 'c-lms-1',
      ),
      SyncInvocation(
        invocationId: 'sync-lms-2', capability: 'lms-utilities',
        operation: 'OFFER_CHECK', outcome: SyncOutcome.success, startedAt: at(7),
        durationMs: 96, deduped: false, source: 'SAVEIN', correlationId: 'c-lms-2',
      ),
      SyncInvocation(
        invocationId: 'sync-lms-3', capability: 'lms-utilities',
        operation: 'BALANCE_CHECK', outcome: SyncOutcome.technicalError,
        startedAt: at(12), durationMs: 2, deduped: false, source: 'SAVEIN',
        correlationId: 'c-lms-3', errorClass: 'PERMANENT',
        errorCode: 'UNKNOWN_REQUEST_CODE',
      ),
    ];
  }

  @override
  Future<SyncInvocationsPage> invocations({
    String? capability,
    String? source,
    SyncOutcome? outcome,
    int page = 0,
    int size = 50,
  }) async {
    final matched = _records
        .where((r) =>
            (capability == null || capability.isEmpty || r.capability == capability) &&
            (source == null ||
                source.isEmpty ||
                (r.source ?? '').toUpperCase() == source.toUpperCase()) &&
            (outcome == null || r.outcome == outcome))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    final sz = math.max(1, math.min(size, 200));
    final totalPages = matched.isEmpty ? 0 : (matched.length + sz - 1) ~/ sz;
    final from = math.min(page * sz, matched.length);
    final to = math.min(from + sz, matched.length);
    return SyncInvocationsPage(
      items: matched.sublist(from, to),
      page: page,
      size: sz,
      totalItems: matched.length,
      totalPages: totalPages,
    );
  }

  @override
  Future<List<SyncInvocation>> byKey(String idempotencyKey) async {
    return _records.where((r) => r.idempotencyKey == idempotencyKey).toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }
}
