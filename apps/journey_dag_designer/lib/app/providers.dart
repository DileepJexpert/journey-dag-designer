/// Application-wide DI wiring (build doc §1.3, §3). Repositories are exposed as
/// abstract types; [Env.useMockBackend] picks the binding — the seeded Mock
/// (default: app and widget tests run without the backend) or the HTTP
/// implementation against the journey-registry. BOTH carry the REAL actor
/// identity from the auth session: the mock stamps it locally, the HTTP client
/// sends it as X-User-Id for the server to enforce maker-checker on.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/auth_controller.dart';
import '../core/config/env.dart';
import 'package:dag_core/dag_core.dart';
import '../data/repositories/http_journey_repository.dart';
import '../data/repositories/mock_capability_repository.dart';
import '../data/repositories/mock_journey_repository.dart';
import '../domain/repositories/capability_repository.dart';
import '../domain/repositories/journey_repository.dart';
import '../domain/services/dag_diff_service.dart';
import '../domain/services/dag_validator.dart';
import '../domain/services/simulation_engine.dart';

// Pure domain services — stateless, safe as singletons.
final dagValidatorProvider = Provider((ref) => const DagValidator());
final configSerializerProvider = Provider((ref) => const ConfigSerializer());
final dagDiffServiceProvider = Provider((ref) => const DagDiffService());
final simulationEngineProvider = Provider((ref) => const SimulationEngine());

/// The CURRENT actor for repository calls — the logged-in user's id, read at
/// call time (not captured at wiring time, so login/logout takes effect
/// immediately). Empty when unauthenticated: the HTTP client then omits
/// X-User-Id and the registry 401s mutations — fail closed server-side.
final currentActorProvider = Provider<String Function()>((ref) {
  return () => ref.read(authControllerProvider).user?.id ?? '';
});

// Repositories — mock (default) or HTTP against the registry, by Env flag.
final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  final actor = ref.watch(currentActorProvider);
  if (Env.useMockBackend) {
    // The mock stamps the SAME identity the live path would send, and mirrors
    // the server's maker-checker rules — mock and live disagree on transport,
    // never on the rules.
    return MockJourneyRepository(actor: actor);
  }
  return HttpJourneyRepository(
    dio: buildDio(
        actorId: actor, baseUrl: Env.apiBaseUrl, registryToken: Env.registryToken),
    serializer: ref.watch(configSerializerProvider),
  );
});

final capabilityRepositoryProvider = Provider<CapabilityRepository>((ref) {
  return const MockCapabilityRepository();
});
