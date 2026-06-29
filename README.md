# Journey DAG Designer

A Flutter (Web-primary, Dart 3) **control-plane authoring tool** for the IDFC
integration platform. Authors compose **journeys as DAGs** from registered
capabilities, preview the generated config, simulate a run (preview only), and
push changes through versioning → maker-checker approval → publish, scoped by
**(businessLine × product × partner)**.

> **Control-plane only.** This app authors config; it never executes journeys
> and never sits in the request hot path. The orchestration **engine** (a
> separate backend) reads the journey registry at runtime and is authoritative.

## Build status

This is the **step 1 + step 2** slice of the build doc
(`DAG_DESIGNER_CLAUDE_CODE_DOC.md`):

- **Step 1 — scaffold:** theme, go_router (+ auth redirect), Riverpod, dio
  client, mock-mode auth login, and seeded `Mock*` repositories. App boots to a
  login → journeys list backed by the in-memory mock (runs with **no backend**).
- **Step 2 — pure domain + services (the spine), unit-tested green:**
  - Models (freezed): `Dag`, sealed `DagNode` (task|branch|terminal), `Journey`,
    `JourneyVersion`, `Capability`, `Binding`, scope dimensions, validation, diff.
  - Services (pure Dart, no Flutter/Dio): `DagValidator`, `ConfigSerializer`
    (the single, **provisional** config-contract emitter — build doc §2),
    `DagDiffService`, `SimulationEngine` (preview-only planner).
  - **33 unit tests pass** (`test/domain/`).

The **canvas/editor, versioning UI, approvals, audit, bindings UI, and
simulation animation are NOT built yet** — they are the next steps and were held
for review per the build doc's stop gate.

## Frontend ↔ backend alignment notes

The orchestration engine does not exist yet, so the DAG config JSON schema
(build doc §5, emitted solely by `ConfigSerializer`) is **PROVISIONAL** and must
later be agreed byte-for-byte with the engine. Two alignment facts captured
against the current backend (`idfc-integration-platform`):

- **Capability keys** mirror the real backend module names under
  `capabilities/`: `bureau`, `customer-party`, `kyc`, `lending-origination`,
  `lending-servicing`, `payments`, `scoring`. The build doc §5 example used
  `scoring-decisioning`, which is **not** a real module — the correct key is
  `scoring`. Seed data and the validator test pin the real names.
- **`businessLine`** values equal the SFDC edge `type` routing dimension
  (`PERSONAL_LOAN`, `LAP`, …). There is **no `tenant`** anywhere in the backend
  (confirmed) — scoping is (businessLine × product × partner) only.

## Run / test

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generated files are committed; only needed after model changes
flutter test            # domain unit tests
flutter run -d chrome   # boots in mock mode (USE_MOCK_BACKEND defaults true)
```

To point at a real registry backend later:
`--dart-define=USE_MOCK_BACKEND=false --dart-define=API_BASE_URL=https://…`
