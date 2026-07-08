/// Per-flavor environment config, mirroring the Designer's `Env` idiom: all
/// values are compile-time `--dart-define`s. With [useMockOpsApi] true
/// (default) the app runs entirely against seeded in-memory fixtures, so it
/// works — and its widget tests run — without any backend.
library;

class OpsEnv {
  const OpsEnv._();

  /// The engine's audited ops read window (B.3). Local default matches the
  /// engine's local profile (`/ops` on the engine port).
  static const String opsApiBaseUrl = String.fromEnvironment(
    'OPS_API_BASE_URL',
    defaultValue: 'http://localhost:8082',
  );

  /// The DIGITAL EDGE's sync-invocation audit surface. The sync lane
  /// (imps-disbursal, lms-utilities) runs IN-THREAD on the edge (:8081), not the
  /// engine — so its `/ops/sync-invocations` records live here, not on the engine
  /// port. Same X-Ops-Token as the engine ops API (one ops token, both surfaces).
  static const String syncApiBaseUrl = String.fromEnvironment(
    'SYNC_OPS_API_BASE_URL',
    defaultValue: 'http://localhost:8081',
  );

  /// The ops API token (X-Ops-Token). DEV default matches the engine's local
  /// profile; real deployments pass their secret at build time. (The engine
  /// fails closed at startup without a configured token — a client-side dev
  /// default can never open a fail-open door server-side. D14: this token does
  /// NOT authorize the registry, nor vice versa.)
  static const String opsToken = String.fromEnvironment(
    'OPS_TOKEN',
    defaultValue: 'dev-ops-token',
  );

  /// The journey-registry (A1) — used ONLY to fetch the pinned version's graph
  /// for rendering. Read-only here.
  static const String registryBaseUrl = String.fromEnvironment(
    'REGISTRY_BASE_URL',
    defaultValue: 'http://localhost:8104',
  );

  static const String registryToken = String.fromEnvironment(
    'REGISTRY_TOKEN',
    defaultValue: 'dev-registry-token',
  );

  /// Pre-asserted operator id (X-User-Id). When empty the app shows the
  /// identity gate and asks. Identity is ASSERTED, not authenticated — SSO is
  /// a tracked production gate, same as the Designer.
  static const String opsUser = String.fromEnvironment(
    'OPS_USER',
    defaultValue: '',
  );

  /// Default OFF: the app reads the REAL engine ops API (`/ops` on the engine).
  /// Widget tests inject the seeded [MockOpsApi] via provider overrides, so they
  /// are unaffected by this default. For a quick backend-free run:
  ///   flutter run --dart-define=USE_MOCK_OPS_API=true
  static const bool useMockOpsApi = bool.fromEnvironment(
    'USE_MOCK_OPS_API',
    defaultValue: false,
  );
}
