/// Composition root: mock everything (default) or the real audited APIs,
/// switched by [OpsEnv.useMockOpsApi]. Tests override these providers.
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/graph_repository.dart';
import '../data/http_ops_api.dart';
import '../data/http_sync_ops_api.dart';
import '../data/mock_ops_api.dart';
import '../data/mock_sync_ops_api.dart';
import '../data/ops_api.dart';
import '../data/sync_ops_api.dart';
import '../domain/models.dart';
import 'env.dart';

/// Wall clock for the Tier-1 live computations (time-in-node, sweeper
/// countdowns, ages). Tests override this with a fixed instant so the
/// arithmetic is deterministic.
final nowProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// The ASSERTED operator id (X-User-Id on every request). Null until the
/// identity gate collects it (or OPS_USER is passed at build time).
final opsActorProvider = StateProvider<String?>(
    (ref) => OpsEnv.opsUser.isEmpty ? null : OpsEnv.opsUser);

final opsApiProvider = Provider<OpsApi>((ref) {
  if (OpsEnv.useMockOpsApi) {
    return MockOpsApi();
  }
  return HttpOpsApi(
    baseUrl: OpsEnv.opsApiBaseUrl,
    opsToken: OpsEnv.opsToken,
    actorId: () => ref.read(opsActorProvider) ?? 'unidentified',
  );
});

/// The sync-lane audit API (digital edge :8081). Distinct from [opsApiProvider]
/// (engine :8082) because sync invocations are not journeys and live on the edge.
final syncOpsApiProvider = Provider<SyncOpsApi>((ref) {
  if (OpsEnv.useMockOpsApi) {
    return MockSyncOpsApi();
  }
  return HttpSyncOpsApi(
    baseUrl: OpsEnv.syncApiBaseUrl,
    opsToken: OpsEnv.opsToken,
    actorId: () => ref.read(opsActorProvider) ?? 'unidentified',
  );
});

final graphRepositoryProvider = Provider<GraphRepository>((ref) {
  if (OpsEnv.useMockOpsApi) {
    return MockGraphRepository();
  }
  return HttpGraphRepository(
    dio: buildDio(
      actorId: () => ref.read(opsActorProvider) ?? 'unidentified',
      baseUrl: OpsEnv.registryBaseUrl,
      registryToken: OpsEnv.registryToken,
    ),
  );
});

/// GET /ops/metrics — per-journey aggregate. autoDispose so it re-fetches each
/// time the metrics screen opens; invalidate to refresh.
final metricsProvider = FutureProvider.autoDispose<OpsMetrics>(
    (ref) => ref.watch(opsApiProvider).metrics());
