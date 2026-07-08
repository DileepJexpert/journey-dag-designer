/// The SYNC-LANE audit read window as the app sees it — GET-shaped by
/// construction (no mutating method). A SEPARATE port from [OpsApi]: sync
/// invocations live on the digital edge (:8081), not the engine (:8082), and are
/// not journeys — so the console keeps them a distinct surface, never faked as
/// runs.
library;

import '../domain/sync_invocation.dart';

abstract interface class SyncOpsApi {
  /// GET /ops/sync-invocations — newest first, server-side filter + pagination.
  Future<SyncInvocationsPage> invocations({
    String? capability,
    String? source,
    SyncOutcome? outcome,
    int page = 0,
    int size = 50,
  });

  /// GET /ops/sync-invocations/by-key/{idempotencyKey} — the transfer + any
  /// deduped replays that carry the business dedup id.
  Future<List<SyncInvocation>> byKey(String idempotencyKey);
}
