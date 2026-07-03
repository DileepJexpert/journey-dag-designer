/// The BANK-CORRECT status vocabulary (spec C.4), mirrored 1:1 from the ops
/// API's `StatusVocabulary` enum. NON-NEGOTIABLE rendering rule: a business
/// decline (COMPLETED—DECLINED) is a NORMAL COMPLETION and must NEVER render
/// with failure styling — a declined loan shown red pages someone at 2am for a
/// correctly-rejected application. The FAILED family splits on the single most
/// triage-relevant bit: was the channel told (an agent re-sends) or not
/// (nobody will — top of triage).
library;

/// How a status renders — the ONLY three visual families the app knows.
enum OpsStatusKind { running, completion, failure }

enum OpsStatus {
  running('RUNNING', 'RUNNING', OpsStatusKind.running),
  completedApproved(
      'COMPLETED_APPROVED', 'COMPLETED—APPROVED', OpsStatusKind.completion),
  completedDeclined(
      'COMPLETED_DECLINED', 'COMPLETED—DECLINED', OpsStatusKind.completion),
  failedSfdcNotified(
      'FAILED_SFDC_NOTIFIED', 'FAILED—SFDC-notified', OpsStatusKind.failure),
  failedNotifyPending(
      'FAILED_NOTIFY_PENDING', 'FAILED—notify-pending', OpsStatusKind.failure);

  const OpsStatus(this.wire, this.label, this.kind);

  /// Exact wire string from the ops API.
  final String wire;

  /// Exact display string (spec vocabulary; em-dash, not hyphen).
  final String label;

  final OpsStatusKind kind;

  /// FAIL CLOSED on unknown statuses: a vocabulary drift between engine and
  /// this view must surface as an error, never as a silently-mislabeled run.
  static OpsStatus parse(String wire) => values.firstWhere(
        (s) => s.wire == wire,
        orElse: () =>
            throw FormatException('unknown ops run status on wire: "$wire"'),
      );
}

/// Has the channel (SFDC/partner) been told the outcome? Mirrors `Notify`.
enum SfdcNotified {
  none('NONE'),
  pending('PENDING'),
  sent('SENT');

  const SfdcNotified(this.wire);
  final String wire;

  static SfdcNotified parse(String wire) => values.firstWhere(
        (s) => s.wire == wire,
        orElse: () =>
            throw FormatException('unknown sfdcNotified on wire: "$wire"'),
      );
}
