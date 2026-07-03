/// TRIAGE ordering (spec C.3/C.4): a FAILED—notify-pending run outranks
/// EVERYTHING — including newer stuck runs — because nobody will tell the
/// channel unless a human acts.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/domain/models.dart';
import 'package:journey_ops_view/domain/ops_status.dart';
import 'package:journey_ops_view/domain/triage.dart';

RunSummary _run(String id, OpsStatus status, DateTime started,
        {bool stuck = false}) =>
    RunSummary(
      runId: id,
      journeyKey: 'loan-origination',
      journeyVersion: 1,
      status: status,
      startedAt: started,
      stuck: stuck,
    );

void main() {
  final base = DateTime.utc(2026, 7, 3, 8);

  test('notify-pending band sits ABOVE stuck band even when stuck is newer', () {
    final oldPending = _run(
        'run-pending-old', OpsStatus.failedNotifyPending, base);
    final newerStuck = _run('run-stuck-new', OpsStatus.running,
        base.add(const Duration(hours: 1)),
        stuck: true);

    final merged = mergeTriage(
        notifyPending: [oldPending], stuckRunning: [newerStuck]);

    expect(merged.map((r) => r.runId).toList(),
        ['run-pending-old', 'run-stuck-new']);
  });

  test('newest first WITHIN each band, runId tiebreak, dedupe by runId', () {
    final p1 = _run('run-p1', OpsStatus.failedNotifyPending, base);
    final p2 = _run('run-p2', OpsStatus.failedNotifyPending,
        base.add(const Duration(minutes: 30)));
    final s1 = _run('run-s1', OpsStatus.running, base, stuck: true);
    final s2 = _run('run-s2', OpsStatus.running,
        base.add(const Duration(minutes: 10)),
        stuck: true);

    final merged = mergeTriage(
      notifyPending: [p1, p2, p1], // duplicate feed entry
      stuckRunning: [s1, s2],
    );

    expect(merged.map((r) => r.runId).toList(),
        ['run-p2', 'run-p1', 'run-s2', 'run-s1']);
  });

  test('isTriage: notify-pending and stuck-running qualify; notified failures '
      'and healthy runs do not', () {
    expect(isTriage(_run('a', OpsStatus.failedNotifyPending, base)), isTrue);
    expect(isTriage(_run('b', OpsStatus.running, base, stuck: true)), isTrue);
    expect(isTriage(_run('c', OpsStatus.running, base)), isFalse);
    expect(isTriage(_run('d', OpsStatus.failedSfdcNotified, base)), isFalse);
    expect(isTriage(_run('e', OpsStatus.completedDeclined, base)), isFalse);
  });
}
