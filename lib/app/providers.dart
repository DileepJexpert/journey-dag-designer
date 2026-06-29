/// Application-wide DI wiring (build doc §1.3, §3). Repositories are exposed as
/// abstract types; the default binding is the seeded Mock so the app runs before
/// the backend exists. Flip to Http* impls via overrides / --dart-define later.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/mock_capability_repository.dart';
import '../data/repositories/mock_journey_repository.dart';
import '../domain/repositories/capability_repository.dart';
import '../domain/repositories/journey_repository.dart';
import '../domain/services/config_serializer.dart';
import '../domain/services/dag_diff_service.dart';
import '../domain/services/dag_validator.dart';
import '../domain/services/simulation_engine.dart';

// Pure domain services — stateless, safe as singletons.
final dagValidatorProvider = Provider((ref) => const DagValidator());
final configSerializerProvider = Provider((ref) => const ConfigSerializer());
final dagDiffServiceProvider = Provider((ref) => const DagDiffService());
final simulationEngineProvider = Provider((ref) => const SimulationEngine());

// Repositories — default to seeded mocks.
final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  return MockJourneyRepository();
});

final capabilityRepositoryProvider = Provider<CapabilityRepository>((ref) {
  return const MockCapabilityRepository();
});
