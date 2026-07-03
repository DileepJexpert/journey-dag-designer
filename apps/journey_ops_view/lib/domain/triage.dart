/// TRIAGE — the saved filter (spec C.3): what needs a human NOW.
///
///   1. FAILED—notify-pending runs (nobody will tell the channel — TOP)
///   2. stuck RUNNING runs (no progress inside the run budget; the sweeper
///      will fire soon — eyes on them BEFORE it does)
///
/// FAILED—SFDC-notified runs are deliberately NOT in triage: the channel
/// knows, an agent re-sends; they remain reachable via the status chips.
library;

import 'models.dart';
import 'ops_status.dart';

/// Merge the two triage feeds, notify-pending first, newest-first within each
/// band, de-duplicated by runId (defensive — the bands cannot overlap today:
/// notify-pending runs are terminal, stuck runs are RUNNING).
List<RunSummary> mergeTriage({
  required List<RunSummary> notifyPending,
  required List<RunSummary> stuckRunning,
}) {
  final seen = <String>{};
  final out = <RunSummary>[];
  for (final band in [notifyPending, stuckRunning]) {
    final sorted = [...band]..sort(_newestFirst);
    for (final r in sorted) {
      if (seen.add(r.runId)) {
        out.add(r);
      }
    }
  }
  return out;
}

int _newestFirst(RunSummary a, RunSummary b) {
  final byStart = b.startedAt.compareTo(a.startedAt);
  return byStart != 0 ? byStart : a.runId.compareTo(b.runId);
}

/// True when this run belongs in the triage list (client-side check used by
/// the mock and by tests; the real feeds come filtered from the server).
bool isTriage(RunSummary r) =>
    r.status == OpsStatus.failedNotifyPending ||
    (r.status == OpsStatus.running && r.stuck);
