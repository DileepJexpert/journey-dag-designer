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
