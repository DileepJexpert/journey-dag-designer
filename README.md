# Journey DAG Designer

A Flutter (Web-primary, Dart 3) **control-plane authoring tool** for the IDFC
integration platform. Authors compose **journeys as DAGs** from registered
capabilities, preview the generated config, simulate a run (preview only), and
push changes through versioning → maker-checker approval → publish, scoped by
**(businessLine × product × partner)**.

> **Control-plane only.** This app authors config; it never executes journeys
> and never sits in the request hot path. The orchestration **engine** (a
> separate backend) reads the journey registry at runtime and is authoritative.

## Workspace layout

This repo is a small multi-package workspace (plain path dependencies — no
melos, no pub workspace feature):

```
apps/journey_dag_designer/   the Designer app (editor, approvals, live registry client)
packages/dag_core/           SHARED read layer: Dag/DagNode models, ConfigSerializer,
                             contract fixtures + lock test, presentational DagCanvasView,
                             dio client, status color tokens
```

`dag_core` exists so the read-only **Journey Ops View** (`apps/journey_ops_view`,
Ops View build) renders journeys with the *same* models, serializer and canvas
the Designer authors with — one schema, one drawing surface. It declares
`flutter: >=3.22` and deliberately uses only version-stable framework APIs.

The **schema contract** with the engine lives in `packages/dag_core/contract/`
(`*.journey.json`), locked by `packages/dag_core/test/contract_lock_test.dart`
and regenerated ONLY as a deliberate co-locked change via
`cd packages/dag_core && dart run tool/emit_contract.dart`.

## Build status

Steps 1–3 of the build doc (`DAG_DESIGNER_CLAUDE_CODE_DOC.md`) are built: the
full editor (canvas, palette, inspector, validation panel, config preview),
versioning + maker-checker approval flows, and a live `HttpJourneyRepository`
against the platform repo's journey-registry (server-enforced 403s surface in
the UI; real logged-in actor on every write). `Env.useMockBackend` switches the
whole data layer between seeded mocks and the live registry.

## Frontend ↔ backend alignment notes

- The DAG config JSON schema (build doc §5) is emitted solely by
  `ConfigSerializer` (now in `dag_core`) and is **locked** to the engine's
  loader via the committed contract fixtures — both sides' tests must re-lock
  together on any schema change.
- **Capability keys** mirror the real backend module names under
  `capabilities/`: `bureau`, `customer-party`, `kyc`, `lending-origination`,
  `lending-servicing`, `payments`, `scoring`. The build doc §5 example used
  `scoring-decisioning`, which is **not** a real module — the correct key is
  `scoring`. Seed data and the validator test pin the real names.
- **`businessLine`** values equal the SFDC edge `type` routing dimension
  (`PERSONAL_LOAN`, `LAP`, …). There is **no `tenant`** anywhere in the backend
  (confirmed) — scoping is (businessLine × product × partner) only.

## Run / test

All app commands run from `apps/journey_dag_designer/`:

```bash
cd apps/journey_dag_designer
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generated files are committed; only needed after model changes
flutter test            # full designer suite
flutter run -d chrome   # boots in mock mode (USE_MOCK_BACKEND defaults true)
```

The shared package has its own (contract-lock) suite:

```bash
cd packages/dag_core
flutter test
```

Against the LIVE journey-registry (the platform repo's
`docs/testing/REGISTRY_RUNBOOK.md` operates the whole seam):

```bash
cd apps/journey_dag_designer
flutter run -d chrome --dart-define=USE_MOCK_BACKEND=false \
  --dart-define=API_BASE_URL=http://localhost:8104 \
  --dart-define=REGISTRY_TOKEN=dev-registry-token
```

`test/integration/registry_live_test.dart` runs the full maker-checker
lifecycle over real HTTP and self-skips when the registry isn't running.

> Toolchain note: `flutter analyze` on an SDK older than ~3.27 reports a
> handful of `withValues`/`initialValue`/`CardThemeData` errors in Designer
> widget files — those APIs are newer than the old SDK, not real defects; build
> and analyze the app on the Flutter version it targets (3.27+). `dag_core`
> intentionally avoids post-3.22 APIs and analyzes clean on any modern SDK.
