/// Per-flavor environment config (build doc §10 environments). The API base URL
/// is supplied at build time via `--dart-define=API_BASE_URL=...`. When
/// [useMockBackend] is true the app runs end-to-end against the in-memory mock,
/// so it works before the backend exists.
library;

class Env {
  const Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// Default ON until the registry backend is reachable. Override with
  /// `--dart-define=USE_MOCK_BACKEND=false`.
  static const bool useMockBackend = bool.fromEnvironment(
    'USE_MOCK_BACKEND',
    defaultValue: true,
  );
}
