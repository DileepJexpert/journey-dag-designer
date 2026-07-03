/// The ops read window as the app sees it — GET-shaped by construction: this
/// port has no method that could mutate anything.
library;

import '../domain/models.dart';
import '../domain/ops_status.dart';

class OpsApiException implements Exception {
  const OpsApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'OpsApiException($statusCode): $message';
}

abstract interface class OpsApi {
  /// GET /ops/runs — newest first, paginated.
  Future<RunsPage> runs({
    OpsStatus? status,
    String? journeyKey,
    bool stuckOnly = false,
    int page = 0,
    int size = 50,
  });

  /// GET /ops/runs/search?key= — EXACT id match only
  /// (runId | correlationId | notificationId | sfdcRecordId).
  Future<List<RunSummary>> search(String key);

  /// GET /ops/runs/{runId} — null when unknown (404).
  Future<RunDetail?> detail(String runId);
}
