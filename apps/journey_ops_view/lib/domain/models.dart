/// Read models of the ops API wire DTOs (RunSummaryDto / RunDetailDto /
/// TransitionDto / PageDto). Deliberately id-shaped like the API itself: there
/// is no field a payload could travel in. Plain immutable classes with manual
/// parsing — no codegen for a read-only console.
library;

import 'ops_status.dart';

class RunSummary {
  const RunSummary({
    required this.runId,
    required this.journeyKey,
    required this.journeyVersion,
    required this.status,
    required this.startedAt,
    this.endedAt,
    this.correlationId,
    this.notificationId,
    this.sfdcRecordId,
    this.stuck = false,
    this.sweepDeadline,
  });

  final String runId;
  final String journeyKey;
  final int journeyVersion;
  final OpsStatus status;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? correlationId;
  final String? notificationId;
  final String? sfdcRecordId;
  final bool stuck;

  /// OPS P2: when the liveness sweeper will force-fail this run (live runs
  /// only; null once terminal) — "the system acts on its own at ⟨t⟩".
  final DateTime? sweepDeadline;

  /// Wall-clock duration for ended runs; null while live.
  Duration? get duration => endedAt?.difference(startedAt);

  factory RunSummary.fromJson(Map<String, dynamic> json) => RunSummary(
        runId: json['runId'] as String,
        journeyKey: json['journeyKey'] as String,
        journeyVersion: (json['journeyVersion'] as num).toInt(),
        status: OpsStatus.parse(json['status'] as String),
        startedAt: DateTime.parse(json['startedAt'] as String),
        endedAt: json['endedAt'] == null
            ? null
            : DateTime.parse(json['endedAt'] as String),
        correlationId: json['correlationId'] as String?,
        notificationId: json['notificationId'] as String?,
        sfdcRecordId: json['sfdcRecordId'] as String?,
        stuck: json['stuck'] as bool? ?? false,
        sweepDeadline: json['sweepDeadline'] == null
            ? null
            : DateTime.parse(json['sweepDeadline'] as String),
      );
}

/// OPS P2: per-node execution stats — dispatch attempts (the T2 retry ladder)
/// and, for terminally-failed nodes, the failure-class ENUM NAME
/// (TRANSIENT / PERMANENT / AMBIGUOUS / BREAKER_OPEN). Names only, never text.
class NodeStat {
  const NodeStat({required this.nodeId, required this.attempts, this.failureClass});

  final String nodeId;
  final int attempts;
  final String? failureClass;

  factory NodeStat.fromJson(Map<String, dynamic> json) => NodeStat(
        nodeId: json['nodeId'] as String,
        attempts: (json['attempts'] as num?)?.toInt() ?? 0,
        failureClass: json['failureClass'] as String?,
      );
}

class TransitionEntry {
  const TransitionEntry({
    required this.seq,
    required this.nodeId,
    required this.status,
    required this.at,
    this.late = false,
  });

  final int seq;
  final String nodeId;

  /// DISPATCHED / COMPLETED / FAILED (node-level, not run-level).
  final String status;
  final DateTime at;
  final bool late;

  factory TransitionEntry.fromJson(Map<String, dynamic> json) =>
      TransitionEntry(
        seq: (json['seq'] as num).toInt(),
        nodeId: json['nodeId'] as String,
        status: json['status'] as String,
        at: DateTime.parse(json['at'] as String),
        late: json['late'] as bool? ?? false,
      );
}

class RunDetail {
  const RunDetail({
    required this.runId,
    required this.journeyKey,
    required this.journeyVersion,
    required this.status,
    required this.sfdcNotified,
    required this.startedAt,
    this.endedAt,
    this.terminalNodeId,
    this.terminalOutcome,
    this.correlationId,
    this.notificationId,
    this.sfdcRecordId,
    this.transitions = const [],
    this.dlqTopicRef,
    this.stuck = false,
    this.sweepDeadline,
    this.nodeStats = const [],
    this.compensationOf,
    this.compensationPending = const [],
  });

  final String runId;
  final String journeyKey;
  final int journeyVersion;
  final OpsStatus status;
  final SfdcNotified sfdcNotified;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? terminalNodeId;
  final String? terminalOutcome;
  final String? correlationId;
  final String? notificationId;
  final String? sfdcRecordId;
  final List<TransitionEntry> transitions;

  /// Pointer ONLY (D13): the DLQ topic name as a starting point for Brod.
  final String? dlqTopicRef;
  final bool stuck;

  /// OPS P2: when the sweeper will act on this run (live only; null terminal).
  final DateTime? sweepDeadline;

  /// OPS P2: per-node attempts + failure classes (empty for pre-P2 records).
  final List<NodeStat> nodeStats;

  /// OPS P2: the node whose failure started the compensation saga, and the
  /// compensation node ids still to be undone (head = in flight).
  final String? compensationOf;
  final List<String> compensationPending;

  /// Wall-clock duration for ended runs; null while live.
  Duration? get duration => endedAt?.difference(startedAt);

  NodeStat? statOf(String nodeId) {
    for (final s in nodeStats) {
      if (s.nodeId == nodeId) return s;
    }
    return null;
  }

  /// A run is terminal when it has ended — nothing on it is "active" anymore.
  bool get isTerminal => status != OpsStatus.running;

  /// Legacy pre-pinning run (D: journeyVersion 0): no version to pin a graph
  /// to — render the CURRENT graph with a "legacy, approximate" badge.
  bool get isLegacyVersion => journeyVersion == 0;

  factory RunDetail.fromJson(Map<String, dynamic> json) => RunDetail(
        runId: json['runId'] as String,
        journeyKey: json['journeyKey'] as String,
        journeyVersion: (json['journeyVersion'] as num).toInt(),
        status: OpsStatus.parse(json['status'] as String),
        sfdcNotified: SfdcNotified.parse(json['sfdcNotified'] as String),
        startedAt: DateTime.parse(json['startedAt'] as String),
        endedAt: json['endedAt'] == null
            ? null
            : DateTime.parse(json['endedAt'] as String),
        terminalNodeId: json['terminalNodeId'] as String?,
        terminalOutcome: json['terminalOutcome'] as String?,
        correlationId: json['correlationId'] as String?,
        notificationId: json['notificationId'] as String?,
        sfdcRecordId: json['sfdcRecordId'] as String?,
        transitions: (json['transitions'] as List<dynamic>? ?? const [])
            .map((t) => TransitionEntry.fromJson(t as Map<String, dynamic>))
            .toList(),
        dlqTopicRef: json['dlqTopicRef'] as String?,
        stuck: json['stuck'] as bool? ?? false,
        sweepDeadline: json['sweepDeadline'] == null
            ? null
            : DateTime.parse(json['sweepDeadline'] as String),
        nodeStats: (json['nodeStats'] as List<dynamic>? ?? const [])
            .map((n) => NodeStat.fromJson(n as Map<String, dynamic>))
            .toList(),
        compensationOf: json['compensationOf'] as String?,
        compensationPending:
            (json['compensationPending'] as List<dynamic>? ?? const [])
                .map((e) => e as String)
                .toList(),
      );
}

class RunsPage {
  const RunsPage({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  final List<RunSummary> items;
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;

  factory RunsPage.fromJson(Map<String, dynamic> json) => RunsPage(
        items: (json['items'] as List<dynamic>)
            .map((r) => RunSummary.fromJson(r as Map<String, dynamic>))
            .toList(),
        page: (json['page'] as num).toInt(),
        size: (json['size'] as num).toInt(),
        totalItems: (json['totalItems'] as num).toInt(),
        totalPages: (json['totalPages'] as num).toInt(),
      );
}

/// GET /ops/metrics — per-journey aggregate (Temporal-style "Workflows"
/// analytics). RAW counts + duration percentiles on the wire; rates are derived
/// here so no non-id number crosses the no-payload boundary.
class JourneyMetric {
  const JourneyMetric({
    required this.journeyKey,
    required this.total,
    required this.running,
    required this.completedApproved,
    required this.completedDeclined,
    required this.failed,
    required this.stuck,
    required this.startedLast24h,
    this.p50Millis,
    this.p95Millis,
  });

  final String journeyKey;
  final int total;
  final int running;
  final int completedApproved;
  final int completedDeclined;
  final int failed;
  final int stuck;
  final int startedLast24h;
  final int? p50Millis;
  final int? p95Millis;

  int get terminal => completedApproved + completedDeclined + failed;
  double get approvalRate => terminal == 0 ? 0 : completedApproved / terminal;
  double get failureRate => terminal == 0 ? 0 : failed / terminal;
  Duration? get p50 => p50Millis == null ? null : Duration(milliseconds: p50Millis!);
  Duration? get p95 => p95Millis == null ? null : Duration(milliseconds: p95Millis!);

  factory JourneyMetric.fromJson(Map<String, dynamic> j) => JourneyMetric(
        journeyKey: j['journeyKey'] as String,
        total: (j['total'] as num).toInt(),
        running: (j['running'] as num).toInt(),
        completedApproved: (j['completedApproved'] as num).toInt(),
        completedDeclined: (j['completedDeclined'] as num).toInt(),
        failed: (j['failed'] as num).toInt(),
        stuck: (j['stuck'] as num).toInt(),
        startedLast24h: (j['startedLast24h'] as num).toInt(),
        p50Millis: (j['p50Millis'] as num?)?.toInt(),
        p95Millis: (j['p95Millis'] as num?)?.toInt(),
      );
}

class OpsMetrics {
  const OpsMetrics({required this.generatedAt, required this.journeys});

  final DateTime generatedAt;
  final List<JourneyMetric> journeys;

  factory OpsMetrics.fromJson(Map<String, dynamic> j) => OpsMetrics(
        generatedAt: DateTime.parse(j['generatedAt'] as String),
        journeys: (j['journeys'] as List<dynamic>)
            .map((e) => JourneyMetric.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
