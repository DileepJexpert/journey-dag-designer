/// The mock must MIRROR the server's query semantics (it stands in for the
/// audited API in demos and widget tests): newest-first + runId tiebreak,
/// exact-id search only, honest pagination math.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/data/mock_ops_api.dart';
import 'package:journey_ops_view/domain/ops_status.dart';

void main() {
  final api = MockOpsApi(now: DateTime.utc(2026, 7, 3, 10));

  test('newest first, honest page math', () async {
    final page = await api.runs(size: 10);
    expect(page.items.first.runId, 'run-pl-001');
    expect(page.totalItems, 25);
    expect(page.totalPages, 3);
    final page2 = await api.runs(size: 10, page: 1);
    expect(page2.items, hasLength(10));
    expect(page2.items.first.startedAt.isBefore(page.items.last.startedAt),
        isTrue);
  });

  test('status filter matches the vocabulary exactly', () async {
    final declined =
        await api.runs(status: OpsStatus.completedDeclined, size: 200);
    expect(declined.items, isNotEmpty);
    expect(declined.items.every((r) => r.status == OpsStatus.completedDeclined),
        isTrue);
    final pending =
        await api.runs(status: OpsStatus.failedNotifyPending, size: 200);
    expect(pending.items.map((r) => r.runId), contains('run-pl-006'));
  });

  test('stuckOnly returns only stuck runs', () async {
    final stuck = await api.runs(stuckOnly: true, size: 200);
    expect(stuck.items.map((r) => r.runId).toList(), ['run-pl-002']);
  });

  test('search is EXACT: full ids hit, prefixes miss', () async {
    expect((await api.search('run-pl-004')).map((r) => r.runId),
        ['run-pl-004']);
    // sfdcRecordId shared by the declined run and its notify-pending retry.
    expect((await api.search('SFDC-9004')).map((r) => r.runId).toSet(),
        {'run-pl-004', 'run-pl-006'});
    expect(await api.search('SFDC-900'), isEmpty);
    expect(await api.search('run-pl'), isEmpty);
  });

  test('detail carries transitions in sequence order; unknown id -> null',
      () async {
    final detail = (await api.detail('run-pl-006'))!;
    expect(detail.transitions.map((t) => t.seq).toList(), [0, 1, 2, 3, 4, 5]);
    expect(detail.dlqTopicRef, 'orig.sfdc.dlq.v1');
    expect(await api.detail('nope'), isNull);
  });
}
