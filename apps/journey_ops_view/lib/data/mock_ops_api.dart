/// Seeded in-memory ops API so the console (and its widget tests) runs with NO
/// backend. Mirrors the server's query semantics: newest-first with runId
/// tiebreak, single status filter, stuckOnly, clamped pagination, EXACT-id
/// search. Fixtures cover every vocabulary status plus the corner cases the
/// view must render: a stuck run, a legacy v0 run, an orphan transition.
library;

import 'dart:math' as math;

import '../domain/models.dart';
import '../domain/ops_status.dart';
import 'ops_api.dart';

class MockOpsApi implements OpsApi {
  MockOpsApi({DateTime? now}) : _now = now ?? DateTime.now().toUtc() {
    _runs = _seed(_now);
  }

  final DateTime _now;
  late final List<RunDetail> _runs;

  @override
  Future<RunsPage> runs({
    OpsStatus? status,
    String? journeyKey,
    bool stuckOnly = false,
    int page = 0,
    int size = 50,
  }) async {
    final matches = _runs.where((r) =>
        (status == null || r.status == status) &&
        (journeyKey == null ||
            journeyKey.isEmpty ||
            r.journeyKey == journeyKey) &&
        (!stuckOnly || r.stuck));
    final sorted = matches.map(_summary).toList()..sort(_newestFirst);
    final sz = math.max(1, math.min(size, 200));
    final totalPages = sorted.isEmpty ? 0 : (sorted.length + sz - 1) ~/ sz;
    final from = math.min(page * sz, sorted.length);
    final to = math.min(from + sz, sorted.length);
    return RunsPage(
      items: sorted.sublist(from, to),
      page: page,
      size: sz,
      totalItems: sorted.length,
      totalPages: totalPages,
    );
  }

  @override
  Future<List<RunSummary>> search(String key) async {
    final k = key.trim();
    if (k.isEmpty) {
      throw const OpsApiException(
          "query parameter 'key' must be a non-blank exact id",
          statusCode: 400);
    }
    return _runs
        .where((r) =>
            r.runId == k ||
            r.correlationId == k ||
            r.notificationId == k ||
            r.sfdcRecordId == k)
        .map(_summary)
        .toList()
      ..sort(_newestFirst);
  }

  @override
  Future<RunDetail?> detail(String runId) async {
    for (final r in _runs) {
      if (r.runId == runId) {
        return r;
      }
    }
    return null;
  }

  static int _newestFirst(RunSummary a, RunSummary b) {
    final byStart = b.startedAt.compareTo(a.startedAt);
    return byStart != 0 ? byStart : a.runId.compareTo(b.runId);
  }

  static RunSummary _summary(RunDetail r) => RunSummary(
        runId: r.runId,
        journeyKey: r.journeyKey,
        journeyVersion: r.journeyVersion,
        status: r.status,
        startedAt: r.startedAt,
        endedAt: r.endedAt,
        correlationId: r.correlationId,
        notificationId: r.notificationId,
        sfdcRecordId: r.sfdcRecordId,
        stuck: r.stuck,
      );

  // ---- fixtures ------------------------------------------------------------

  static List<RunDetail> _seed(DateTime now) {
    TransitionEntry t(int seq, String node, String status, int minutesAgo,
            {bool late = false}) =>
        TransitionEntry(
            seq: seq,
            nodeId: node,
            status: status,
            at: now.subtract(Duration(minutes: minutesAgo)),
            late: late);

    final runs = <RunDetail>[
      // Fresh RUNNING on v2 (the current version).
      RunDetail(
        runId: 'run-pl-001',
        journeyKey: 'loan-origination',
        journeyVersion: 2,
        status: OpsStatus.running,
        sfdcNotified: SfdcNotified.none,
        startedAt: now.subtract(const Duration(minutes: 2)),
        correlationId: 'corr-001',
        notificationId: 'NTF-001',
        sfdcRecordId: 'SFDC-9001',
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 2),
          t(1, 'n_customer', 'COMPLETED', 2),
          t(2, 'n_kyc', 'DISPATCHED', 1),
        ],
      ),
      // STUCK running on v1 — in triage until the sweeper fires.
      RunDetail(
        runId: 'run-pl-002',
        journeyKey: 'loan-origination',
        journeyVersion: 1,
        status: OpsStatus.running,
        sfdcNotified: SfdcNotified.none,
        startedAt: now.subtract(const Duration(minutes: 40)),
        correlationId: 'corr-002',
        notificationId: 'NTF-002',
        sfdcRecordId: 'SFDC-9002',
        stuck: true,
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 40),
          t(1, 'n_customer', 'COMPLETED', 39),
          t(2, 'n_kyc', 'DISPATCHED', 39),
        ],
      ),
      // Happy path, pinned v1.
      RunDetail(
        runId: 'run-pl-003',
        journeyKey: 'loan-origination',
        journeyVersion: 1,
        status: OpsStatus.completedApproved,
        sfdcNotified: SfdcNotified.sent,
        startedAt: now.subtract(const Duration(hours: 3)),
        endedAt: now.subtract(const Duration(hours: 3, minutes: -4)),
        terminalNodeId: 'n_done',
        terminalOutcome: 'APPROVED',
        correlationId: 'corr-003',
        notificationId: 'NTF-003',
        sfdcRecordId: 'SFDC-9003',
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 180),
          t(1, 'n_customer', 'COMPLETED', 180),
          t(2, 'n_kyc', 'DISPATCHED', 179),
          t(3, 'n_kyc', 'COMPLETED', 179),
          t(4, 'n_bureau', 'DISPATCHED', 178),
          t(5, 'n_bureau', 'COMPLETED', 178),
          t(6, 'n_score', 'DISPATCHED', 177),
          t(7, 'n_score', 'COMPLETED', 177),
          t(8, 'n_book', 'DISPATCHED', 176),
          t(9, 'n_book', 'COMPLETED', 176),
        ],
      ),
      // Business DECLINE — a NORMAL completion (never renders as failure).
      RunDetail(
        runId: 'run-pl-004',
        journeyKey: 'loan-origination',
        journeyVersion: 1,
        status: OpsStatus.completedDeclined,
        sfdcNotified: SfdcNotified.sent,
        startedAt: now.subtract(const Duration(hours: 5)),
        endedAt: now.subtract(const Duration(hours: 5, minutes: -3)),
        terminalNodeId: 'n_reject',
        terminalOutcome: 'REJECTED',
        correlationId: 'corr-004',
        notificationId: 'NTF-004',
        sfdcRecordId: 'SFDC-9004',
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 300),
          t(1, 'n_customer', 'COMPLETED', 300),
          t(2, 'n_kyc', 'DISPATCHED', 299),
          t(3, 'n_kyc', 'COMPLETED', 299),
          t(4, 'n_bureau', 'DISPATCHED', 298),
          t(5, 'n_bureau', 'COMPLETED', 298),
          t(6, 'n_score', 'DISPATCHED', 297),
          t(7, 'n_score', 'COMPLETED', 297),
        ],
      ),
      // Failure the channel WAS told about (agent re-sends; not in triage).
      RunDetail(
        runId: 'run-pl-005',
        journeyKey: 'loan-origination',
        journeyVersion: 1,
        status: OpsStatus.failedSfdcNotified,
        sfdcNotified: SfdcNotified.sent,
        startedAt: now.subtract(const Duration(hours: 8)),
        endedAt: now.subtract(const Duration(hours: 8, minutes: -2)),
        terminalNodeId: 'n_kyc',
        terminalOutcome: 'ERROR',
        correlationId: 'corr-005',
        notificationId: 'NTF-005',
        sfdcRecordId: 'SFDC-9005',
        dlqTopicRef: 'orig.sfdc.dlq.v1',
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 480),
          t(1, 'n_customer', 'COMPLETED', 480),
          t(2, 'n_kyc', 'DISPATCHED', 479),
          t(3, 'n_kyc', 'FAILED', 478),
        ],
      ),
      // Failure NOBODY was told about — TOP of triage.
      RunDetail(
        runId: 'run-pl-006',
        journeyKey: 'loan-origination',
        journeyVersion: 2,
        status: OpsStatus.failedNotifyPending,
        sfdcNotified: SfdcNotified.pending,
        startedAt: now.subtract(const Duration(hours: 1)),
        endedAt: now.subtract(const Duration(minutes: 55)),
        terminalNodeId: 'n_bureau',
        terminalOutcome: 'ERROR',
        correlationId: 'corr-006',
        notificationId: 'NTF-006',
        sfdcRecordId: 'SFDC-9004', // same SFDC record as run-pl-004: related runs
        dlqTopicRef: 'orig.sfdc.dlq.v1',
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 60),
          t(1, 'n_customer', 'COMPLETED', 60),
          t(2, 'n_kyc', 'DISPATCHED', 59),
          t(3, 'n_kyc', 'COMPLETED', 59),
          t(4, 'n_bureau', 'DISPATCHED', 58),
          t(5, 'n_bureau', 'FAILED', 56, late: true),
        ],
      ),
      // LEGACY pre-pinning run (v0): current graph + "legacy, approximate"
      // badge; one transition references a node the current graph lost.
      RunDetail(
        runId: 'run-pl-007',
        journeyKey: 'loan-origination',
        journeyVersion: 0,
        status: OpsStatus.completedApproved,
        sfdcNotified: SfdcNotified.sent,
        startedAt: now.subtract(const Duration(days: 30)),
        endedAt: now.subtract(const Duration(days: 30, hours: -1)),
        terminalNodeId: 'n_done',
        terminalOutcome: 'APPROVED',
        correlationId: 'corr-007',
        notificationId: 'NTF-007',
        sfdcRecordId: 'SFDC-9007',
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 43200),
          t(1, 'n_customer', 'COMPLETED', 43200),
          t(2, 'n_legacy_check', 'DISPATCHED', 43199),
          t(3, 'n_legacy_check', 'COMPLETED', 43199),
          t(4, 'n_book', 'DISPATCHED', 43198),
          t(5, 'n_book', 'COMPLETED', 43198),
        ],
      ),
    ];

    // Pagination filler: completed runs spread over the past week.
    for (var i = 0; i < 18; i++) {
      final started = now.subtract(Duration(hours: 24 + i * 7));
      runs.add(RunDetail(
        runId: 'run-fill-${(i + 1).toString().padLeft(3, '0')}',
        journeyKey: 'loan-origination',
        journeyVersion: 1,
        status: i % 3 == 0
            ? OpsStatus.completedDeclined
            : OpsStatus.completedApproved,
        sfdcNotified: SfdcNotified.sent,
        startedAt: started,
        endedAt: started.add(const Duration(minutes: 5)),
        terminalNodeId: i % 3 == 0 ? 'n_reject' : 'n_done',
        terminalOutcome: i % 3 == 0 ? 'REJECTED' : 'APPROVED',
        correlationId: 'corr-fill-$i',
        notificationId: 'NTF-F$i',
        sfdcRecordId: 'SFDC-F$i',
        transitions: [
          t(0, 'n_customer', 'DISPATCHED', 24 * 60 + i * 420),
          t(1, 'n_customer', 'COMPLETED', 24 * 60 + i * 420),
        ],
      ));
    }
    return runs;
  }
}
