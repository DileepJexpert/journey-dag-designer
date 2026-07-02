/// Per-flavor environment config (build doc §10 environments). The registry
/// base URL and service token are supplied at build time via `--dart-define`.
/// When [useMockBackend] is true the app runs end-to-end against the in-memory
/// mock, so it works without the backend.
library;

class Env {
  const Env._();

  /// The journey-registry service (A1). Local default matches its local profile.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8104',
  );

  /// The registry service token (X-Registry-Token). The DEV default matches the
  /// registry's local profile; real deployments pass their secret at build time.
  /// (The registry itself fails closed at startup without a configured token —
  /// this client-side default can never open a fail-open door server-side.)
  static const String registryToken = String.fromEnvironment(
    'REGISTRY_TOKEN',
    defaultValue: 'dev-registry-token',
  );

  /// Default ON so the app (and widget tests) run without the backend.
  /// Run against the real registry with:
  ///   flutter run --dart-define=USE_MOCK_BACKEND=false
  static const bool useMockBackend = bool.fromEnvironment(
    'USE_MOCK_BACKEND',
    defaultValue: true,
  );
}
