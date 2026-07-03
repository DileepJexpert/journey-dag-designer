/// Composition root: mock everything (default) or the real audited APIs,
/// switched by [OpsEnv.useMockOpsApi]. Tests override these providers.
library;

import 'package:dag_core/dag_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/graph_repository.dart';
import '../data/http_ops_api.dart';
import '../data/mock_ops_api.dart';
import '../data/ops_api.dart';
import 'env.dart';

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
