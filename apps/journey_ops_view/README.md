# journey_ops_view — the read-only ops console

The ops floor's forensic window over journey runs. A **separate app** from the
Designer on purpose: the Designer writes the control plane (authoring,
maker-checker, publish); this console reads the data plane (runs, timelines,
triage). They share `packages/dag_core` (models, serializer, canvas) so a
journey looks identical in both — and nothing else.

**Read-only by construction, not by discipline.** The `OpsApi` port has no
mutating method, no screen has a write affordance, and the bundled registry
client can only fetch published versions — the console's whole security
argument is that the write code doesn't exist in it.

## The wire it reads

| endpoint | purpose |
|---|---|
| `GET /ops/runs` | paged list; filters: status, journeyKey, stuckOnly, since/until |
| `GET /ops/runs/search?key=` | EXACT id match: runId / correlationId / notificationId / sfdcRecordId |
| `GET /ops/runs/{runId}` | one run: identity, transitions, node stats, saga state, DLQ *ref* |

Every request carries `X-Ops-Token` (read scope — never interchangeable with
the registry token, verified live both directions) plus `X-User-Id` (asserted
operator id; SSO is the production gate), and every attempt is audit-logged
server-side. Every DTO field is **id-shaped** — ids, enums, timestamps,
counts. The platform's `NoPayloadDtoProofTest` structurally rejects any field
a payload (a PAN, a mobile number) could travel in; new fields do not ship
without passing it.

## Status vocabulary (server-computed, fixed)

`RUNNING` · `COMPLETED—APPROVED` · `COMPLETED—DECLINED` (a NORMAL completion —
never red) · `FAILED—SFDC-notified` · `FAILED—notify-pending` (top of triage),
plus the `STUCK` marker on live runs that outlived the liveness window.
Unknown statuses fail closed: the view throws rather than mislabel a run.

## Triage depth (OPS P2)

- **Status tiles** — running / stuck / notify-pending / failed-notified counts,
  tap = filter. v1 mechanism: four size-1 `totalItems` reads per poll; a real
  counts endpoint replaces it if the tile row grows — do not let the hack
  calcify.
- **Durations** — `took 4m 00s` on ended rows/headers; `live for … · in
  ⟨node⟩ for …` on live ones.
- **Sweeper deadline** — `sweeper acts at ⟨IST⟩ (in …)` from the wire's
  `sweepDeadline` (startedAt + run budget, live runs only), flipping to
  `sweeper OVERDUE — force-fail imminent` past it.
- **Node stats** — dispatch attempts (`try 2/3` on the canvas, `attempts N`
  on the timeline) and the failure CLASS on failed nodes
  (`failed · PERMANENT`). Classes are enum NAMES only —
  `TRANSIENT / PERMANENT / AMBIGUOUS / BREAKER_OPEN` — never message text.
- **Compensation progress** — on COMPENSATING runs: which node's failure
  started the saga, which undo steps are still pending, and that the decision
  already went to the channel.
- **Timeline latency chips** — `+90s` deltas between consecutive transitions:
  which hop was slow, not just which failed.

## Deliberately never, regardless of demand (Tier 3)

- **Payload/applicant data, DLQ message content** — the DLQ *ref* is the
  boundary; content lives in the masked Brod tooling.
- **Any mutation** (retry/requeue/cancel buttons) — the console's whole
  security argument is that the write code doesn't exist in it.
- **Free-text error messages on the wire** — enum classes only.
- **SSE/streaming and recursive subjourney inlining** — excluded by the spec;
  15s polling is the chosen mechanism.

Demoted, not never (revisit with an answer, not by default): a circuit-breaker
panel (breaker state is per-replica; fleet aggregation is SENTINEL's job) and
a distinct journey-key endpoint (derive client-side).

## Running it

```sh
# LIVE by default: reads the engine's audited /ops window (all services connected).
flutter run -d chrome \
  --dart-define=OPS_API_BASE_URL=http://localhost:8082 \
  --dart-define=OPS_TOKEN=dev-ops-token \
  --dart-define=REGISTRY_BASE_URL=http://localhost:8104 \
  --dart-define=REGISTRY_TOKEN=dev-registry-token \
  --dart-define=OPS_USER=ops.analyst1         # skip the identity gate
flutter run -d chrome --dart-define=USE_MOCK_OPS_API=true   # seeded fixtures, no backend
flutter test                                  # the behavior suite
```
