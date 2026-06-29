# Journey DAG Designer — Claude Code Build Doc

| | |
|---|---|
| **App** | Journey DAG Designer — control-plane authoring tool for the IDFC integration platform |
| **Stack** | Flutter (Web primary; desktop-capable), Dart 3 |
| **Repo** | SEPARATE repo `journey-dag-designer` (NOT inside idfc-integration-platform — that is the Java backend) |
| **Status** | Build doc v1 (evidence-corrected) |

> **What this app is:** a visual editor where authors compose **journeys as DAGs** from registered
> capabilities, preview the generated config, simulate a run, and push changes through
> **versioning → maker-checker approval → publish**, scoped by (businessLine × product × partner),
> all audited. **Control-plane only — it never sits in the request hot path.** It reads/writes the
> **journey registry** via the backend API; the orchestration ENGINE (separate backend) reads that
> registry at runtime. This app authors config; it never executes journeys.

---

## 0. Corrected vocabulary (evidence-based — read first)

Use EXACTLY these scoping dimensions. Do NOT introduce "tenant" or "cell".

| Term | Meaning | Examples |
|---|---|---|
| **businessLine** (`type`) | the routing dimension the SFDC edge already uses | PERSONAL_LOAN, LAP, BUSINESS_LOAN, COMMERCIAL |
| **product** | the loan product | ACEPL, LAS, … |
| **partner** | external origination source (CONFIG, not a service) | CRED, FLIPKART, GROWW, EBC, ASIRVAD, (none/assisted) |
| **domain / businessUnit** | business area that OWNS a capability (ownership label only, NOT a scope axis) | Urban Liability, Urban Assets, Lending, Payments, KYC |
| ~~tenant~~ | NOT USED — does not exist in this domain | — |
| ~~cell~~ | NOT USED — cell framework is shelved | — |

**A journey is scoped/bound by (businessLine × product × partner). NOT by tenant. NOT by cell.**
Onboarding a new partner or product = a new binding/config row → **no new service**.

---

## 1. Architecture principles

1. Clean layering, feature-first: presentation → application(state) → domain → data. The **domain is
   pure Dart** (no Flutter, no Dio).
2. Graph logic is backend- and UI-agnostic — validation, serialization, diff, simulation are PURE
   domain services.
3. Repository pattern with interfaces — abstract `JourneyRepository`; `Http*` + `Mock*` impls.
4. Immutable domain models (freezed).
5. Client validation MIRRORS server schema; server re-validates authoritatively.
6. Maker != checker, enforced in UI AND backend (403).
7. This app SIMULATES for preview only — it NEVER executes.

---

## 2. Critical precondition

**The DAG config JSON schema is a shared contract between this app's `ConfigSerializer` and the
orchestration ENGINE's loader. They must agree byte-for-byte.** The engine does not exist yet; until
the schema is locked, build against §5 (the working contract), keep `ConfigSerializer` the single
source of config output, and mark the schema PROVISIONAL where emitted.

---

## 5. Domain model + DAG config schema (PROVISIONAL contract)

Sealed `DagNode` union: `task | branch | terminal`. Canonical config JSON:

```json
{
  "key": "loan-origination",
  "startNodeId": "n_customer",
  "nodes": [
    {"type":"task","id":"n_customer","capabilityKey":"customer-party","next":["n_kyc"]},
    {"type":"task","id":"n_kyc","capabilityKey":"kyc","next":["n_bureau"]},
    {"type":"task","id":"n_bureau","capabilityKey":"bureau","next":["n_score"]},
    {"type":"task","id":"n_score","capabilityKey":"scoring","next":["n_decide"]},
    {"type":"branch","id":"n_decide","arms":[
        {"expression":"decision == 'APPROVED'","next":"n_book"},
        {"expression":"decision == 'REJECTED'","next":"n_reject"}]},
    {"type":"task","id":"n_book","capabilityKey":"lending-origination","meter":"finnone_pool",
       "compensation":"n_reverse","next":["n_done"]},
    {"type":"terminal","id":"n_done","action":"push_decision_to_channel","emit":["LoanBooked"]},
    {"type":"terminal","id":"n_reject","action":"push_decision_to_channel","emit":["LoanRejected"]}
  ],
  "layout": {"n_customer":{"x":80,"y":200}}
}
```

> NOTE (alignment correction): the original example used `capabilityKey:"scoring-decisioning"`. The
> real backend capability module is **`scoring`** — this doc and the code use `scoring`.

---

## 6. Pure domain services (unit-tested first)

- **DagValidator** → ValidationResult(errors, warnings): exactly one reachable start; all nodes
  reachable; acyclic; every branch arm reaches a terminal; `joinOn` references real predecessors that
  actually precede; any node with `meter` or a money/booking capability MUST define `compensation`;
  every `capabilityKey` exists in the capability registry.
- **ConfigSerializer** → Dag ↔ JSON (canonical) + Dag → YAML (preview). The single contract emitter.
- **DagDiffService** → compute(oldDag,newDag) → DagDiff{addedNodes, removedNodes, changedNodes,
  addedEdges, removedEdges}.
- **SimulationEngine** → plan(dag, decisions) → List<RunStep> (a RunStep = nodes firing together).
  PREVIEW ONLY — deterministic, no real capability behavior.

---

## 9. Backend / registry API (consumed; Mock impl first)

REST/JSON, JWT bearer, roles (maker/checker) in claims. Endpoints include `/auth/login`,
`/capabilities`, `/business-lines`, `/products`, `/partners`, `/journeys` (+ `/{id}`, `/versions/{v}`,
`/validate`, `/submit`, `/approve`, `/reject`, `/simulate`, `/diff`), `/audit`, `/bindings`.

---

## 11. Build order (strict; domain before UI)

1. Scaffold (theme, router, Riverpod, dio, auth login, MockJourneyRepository).
2. **Domain models + the four pure services WITH unit tests — before any UI. STOP and show these
   green before building the canvas.**
3. Data layer (DTOs, mappers, JourneyApi, Http* + Mock* repos).
4. Journey list (load/create/clone).
5. Editor canvas (EditorController + DagCanvas) + live config preview.
6. Validation panel. 7. Versioning + diff. 8. Maker-checker + audit. 9. Bindings.
10. Simulation animation. 11. Polish (golden tests, empty/error states, shortcuts).

---

## 13. Open inputs to confirm

1. Capability registry shape (key, name, ports, isMoneyOrBookingNode).
2. DAG config schema — must be locked WITH the orchestration engine team (§2); §5 is provisional.
3. Auth — token format + role claim names (maker/checker vs actual strings).
4. Scoping confirm — businessLine/product/partner are the real dimensions; there is no `tenant`
   (confirmed against the backend).
