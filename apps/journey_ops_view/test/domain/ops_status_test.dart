/// The status vocabulary parses the EXACT wire strings and fails closed on
/// anything else — a drifted engine enum must surface as an error, never as a
/// silently-mislabeled run.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:journey_ops_view/domain/ops_status.dart';

void main() {
  test('parses every wire status to the right vocabulary entry', () {
    expect(OpsStatus.parse('RUNNING'), OpsStatus.running);
    expect(OpsStatus.parse('COMPLETED_APPROVED'), OpsStatus.completedApproved);
    expect(OpsStatus.parse('COMPLETED_DECLINED'), OpsStatus.completedDeclined);
    expect(
        OpsStatus.parse('FAILED_SFDC_NOTIFIED'), OpsStatus.failedSfdcNotified);
    expect(OpsStatus.parse('FAILED_NOTIFY_PENDING'),
        OpsStatus.failedNotifyPending);
  });

  test('display labels are the exact spec vocabulary (em-dashes and all)', () {
    expect(OpsStatus.running.label, 'RUNNING');
    expect(OpsStatus.completedApproved.label, 'COMPLETED—APPROVED');
    expect(OpsStatus.completedDeclined.label, 'COMPLETED—DECLINED');
    expect(OpsStatus.failedSfdcNotified.label, 'FAILED—SFDC-notified');
    expect(OpsStatus.failedNotifyPending.label, 'FAILED—notify-pending');
  });

  test('a DECLINED completion is kind=completion, never failure', () {
    expect(OpsStatus.completedDeclined.kind, OpsStatusKind.completion);
  });

  test('unknown wire status fails closed', () {
    expect(() => OpsStatus.parse('EXPLODED'), throwsFormatException);
    expect(() => SfdcNotified.parse('MAYBE'), throwsFormatException);
  });
}
