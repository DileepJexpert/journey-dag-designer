/// The SYNC-LANE audit models — the counterpart to the journey run models, but
/// for in-thread calls that never touch the engine (imps-disbursal money
/// movement, lms-utilities queries). Id-shaped and PII-safe like the run models:
/// there is no field a payload could travel in.
///
/// The outcome vocabulary mirrors the edge's `SyncOutcome` enum 1:1, and its
/// RULE is the same: a read that correctly returns "none" is SUCCESS (never a
/// failure); a refused action is BUSINESS_FAILURE; a break is TECHNICAL_ERROR.
library;

/// How a sync outcome renders — reuses the journey families so the whole console
/// speaks one colour language (a business "no" is teal, never red).
enum SyncOutcome {
  success('SUCCESS', 'SUCCESS'),
  businessFailure('BUSINESS_FAILURE', 'BUSINESS—no'),
  technicalError('TECHNICAL_ERROR', 'TECHNICAL—error');

  const SyncOutcome(this.wire, this.label);

  /// Exact wire string from the sync-audit API.
  final String wire;

  /// Short display string.
  final String label;

  /// FAIL CLOSED on unknown outcomes: a vocabulary drift must surface as an
  /// error, never a silently-mislabeled record.
  static SyncOutcome parse(String wire) => values.firstWhere(
        (o) => o.wire == wire,
        orElse: () =>
            throw FormatException('unknown sync outcome on wire: "$wire"'),
      );
}

class SyncInvocation {
  const SyncInvocation({
    required this.invocationId,
    required this.capability,
    required this.operation,
    required this.outcome,
    required this.startedAt,
    required this.durationMs,
    required this.deduped,
    this.source,
    this.idempotencyKey,
    this.correlationId,
    this.transactionId,
    this.errorClass,
    this.errorCode,
  });

  final String invocationId;
  final String capability;
  final String operation;
  final SyncOutcome outcome;
  final DateTime startedAt;
  final int durationMs;

  /// True when this call was an idempotent replay (no new side-effect) — a
  /// repeat money-movement request that returned the prior result.
  final bool deduped;

  final String? source;
  final String? idempotencyKey;
  final String? correlationId;

  /// Downstream reference (e.g. IMPS transactionId) when one came back.
  final String? transactionId;

  /// For TECHNICAL_ERROR only: the ErrorClass name + code (ids, never text).
  final String? errorClass;
  final String? errorCode;

  Duration get duration => Duration(milliseconds: durationMs);

  factory SyncInvocation.fromJson(Map<String, dynamic> json) => SyncInvocation(
        invocationId: json['invocationId'] as String,
        capability: json['capability'] as String,
        operation: json['operation'] as String? ?? '',
        outcome: SyncOutcome.parse(json['outcome'] as String),
        startedAt: DateTime.parse(json['startedAt'] as String),
        durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
        deduped: json['deduped'] as bool? ?? false,
        source: json['source'] as String?,
        idempotencyKey: json['idempotencyKey'] as String?,
        correlationId: json['correlationId'] as String?,
        transactionId: json['transactionId'] as String?,
        errorClass: json['errorClass'] as String?,
        errorCode: json['errorCode'] as String?,
      );
}

class SyncInvocationsPage {
  const SyncInvocationsPage({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  final List<SyncInvocation> items;
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;

  factory SyncInvocationsPage.fromJson(Map<String, dynamic> json) =>
      SyncInvocationsPage(
        items: (json['items'] as List<dynamic>)
            .map((e) => SyncInvocation.fromJson(e as Map<String, dynamic>))
            .toList(),
        page: (json['page'] as num).toInt(),
        size: (json['size'] as num).toInt(),
        totalItems: (json['totalItems'] as num).toInt(),
        totalPages: (json['totalPages'] as num).toInt(),
      );
}
