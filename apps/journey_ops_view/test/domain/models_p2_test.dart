/// OPS P2 wire additions parse (and default) correctly: sweepDeadline,
/// nodeStats (attempts + failure-class ENUM NAME — never a message),
/// compensation progress, the duration getters the rows/headers render,
/// and the formatDuration text itself.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/domain/models.dart';
import 'package:journey_ops_view/features/common/timestamp_text.dart';

void main() {
  test('RunDetail.fromJson parses the P2 fields', () {
    final detail = RunDetail.fromJson({
      'runId': 'r1',
      'journeyKey': 'loan-origination',
      'journeyVersion': 2,
      'status': 'RUNNING',
      'sfdcNotified': 'NONE',
      'startedAt': '2026-07-03T10:00:00Z',
      'sweepDeadline': '2026-07-03T10:15:00Z',
      'nodeStats': [
        {'nodeId': 'n_kyc', 'attempts': 2},
        {'nodeId': 'n_bureau', 'attempts': 3, 'failureClass': 'TRANSIENT'},
      ],
      'compensationOf': 'n_kyc',
      'compensationPending': ['n_customer'],
    });

    expect(detail.sweepDeadline, DateTime.utc(2026, 7, 3, 10, 15));
    expect(detail.statOf('n_kyc')!.attempts, 2);
    expect(detail.statOf('n_kyc')!.failureClass, isNull);
    expect(detail.statOf('n_bureau')!.failureClass, 'TRANSIENT');
    expect(detail.statOf('n_missing'), isNull);
    expect(detail.compensationOf, 'n_kyc');
    expect(detail.compensationPending, ['n_customer']);
    expect(detail.duration, isNull, reason: 'still live — no duration yet');
  });

  test('pre-P2 JSON (fields absent) parses to safe defaults, not throws', () {
    final detail = RunDetail.fromJson({
      'runId': 'r0',
      'journeyKey': 'loan-origination',
      'journeyVersion': 1,
      'status': 'COMPLETED_APPROVED',
      'sfdcNotified': 'SENT',
      'startedAt': '2026-07-03T09:00:00Z',
      'endedAt': '2026-07-03T09:04:00Z',
    });

    expect(detail.sweepDeadline, isNull);
    expect(detail.nodeStats, isEmpty);
    expect(detail.compensationOf, isNull);
    expect(detail.compensationPending, isEmpty);
    expect(detail.duration, const Duration(minutes: 4));
  });

  test('RunSummary: sweepDeadline optional; duration only once ended', () {
    final live = RunSummary.fromJson({
      'runId': 'r1',
      'journeyKey': 'loan-origination',
      'journeyVersion': 2,
      'status': 'RUNNING',
      'startedAt': '2026-07-03T10:00:00Z',
      'sweepDeadline': '2026-07-03T10:15:00Z',
    });
    expect(live.sweepDeadline, DateTime.utc(2026, 7, 3, 10, 15));
    expect(live.duration, isNull);

    final ended = RunSummary.fromJson({
      'runId': 'r0',
      'journeyKey': 'loan-origination',
      'journeyVersion': 1,
      'status': 'COMPLETED_DECLINED',
      'startedAt': '2026-07-03T09:00:00Z',
      'endedAt': '2026-07-03T09:03:00Z',
    });
    expect(ended.sweepDeadline, isNull);
    expect(ended.duration, const Duration(minutes: 3));
  });

  test('NodeStat.fromJson: attempts default 0, class stays a bare enum name',
      () {
    final stat = NodeStat.fromJson({'nodeId': 'n_kyc'});
    expect(stat.attempts, 0);
    expect(stat.failureClass, isNull);

    final failed = NodeStat.fromJson(
        {'nodeId': 'n_book', 'attempts': 1, 'failureClass': 'BREAKER_OPEN'});
    expect(failed.failureClass, 'BREAKER_OPEN');
  });

  test('formatDuration renders floor-readable wall-clock text', () {
    expect(formatDuration(const Duration(seconds: 12)), '12s');
    expect(formatDuration(const Duration(minutes: 4, seconds: 5)), '4m 05s');
    expect(formatDuration(const Duration(hours: 1, minutes: 2)), '1h 02m');
    expect(formatDuration(const Duration(seconds: -30)), '0s',
        reason: 'clock skew must clamp to zero, never render negative');
  });
}
