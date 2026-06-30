# Jira Task Draft — AI Roofing Cost Estimator (roofdata-sprint)

> **Board:** RDS (pending Vauyani) | **Structure:** Epic → User Story → Sub-task + QA sub-task | **AC rule:** On QA sub-task only (≥3 criteria)

---

## Epic 1 — Cost Estimator

### US 1.1 — Natural language cost estimate
**As a** Building Owner or Super Admin, **I want** to type a plain-English roofing cost question, **so that** I receive a data-backed material and labour cost estimate.

**Sub-task 1.1.1 — Implement Query Intent Parser**
Heuristic/regex classifier. Extracts `{ membraneType, jobType, sqft, state, city, bidYearFilter }`. Returns `'OUT_OF_SCOPE'` when zero roofing params. `bidYearFilter` always string `'2024'`. See tech spec §4, GRILL_SESSION A1.

**Sub-task 1.1.2 — Implement Category ID Resolver**
In-process Map cache, 1-hour TTL. Returns `null` for unmatched labels. See tech spec §4, A2.

**Sub-task 1.1.3 — Implement Data Graph API Client**
Authenticated HTTP client. `queryIntakeForms`, `getCategories`, `getProject`. Credentials from `process.env`. `bid_year` always string. Geo widening: city → state → region if `matchCount < 5`. Typed errors: `AuthError` (→ Vauyani alert), `NotFoundError`, `RateLimitError`, `ServerError`. See A4.

**Sub-task 1.1.4 — Implement Labour/Material Ratio Processor**
Named constants: overlay 35/65, full-replacement 45/55, repair 50/50. Fallback to full-replacement for unknown type. Throw on invalid `avgPerSqft`. Write unit tests (all three types + fallback + invalid). See A5.

**Sub-task 1.1.5 — Implement Claude Context Builder**
Load system prompt from `prompts/estimator-system-prompt.txt` at startup. `max_tokens: 1000`. Intercept `OUT_OF_SCOPE` sentinel. One retry after 30s on transient failures. See A6, A7.

**Sub-task 1.1.6 — Implement POST /api/ai/estimate route**
Express route. Middleware stack: auth → `rbacMiddleware(['building_owner', 'super_admin'])` → handler. Calls: Intent Parser → Session Context → Category Resolver → Data Graph API → Ratio Processor → Context Builder → return response. Structured JSON logging.

**Sub-task 1.1.QA — QA: estimate endpoint**
`qa-subtask`
**AC:**
1. Valid query → HTTP 200 with all required fields populated.
2. Off-topic query → HTTP 400 `{ outOfScope: true }` with no Data Graph or Claude API call (verify via logs).
3. Prompt injection → same 400 response + `INJECTION_ATTEMPT` flag in logs.
4. `bid_year` always passed as string `'2024'` — verified by payload inspection.
5. Roofer role → HTTP 403 before any query executes.

---

### US 1.2 — Results card UI
**As a** Building Owner or Super Admin, **I want** a structured mobile-responsive results card, **so that** I can read cost estimates at a glance on any device.

**Sub-task 1.2.1 — Implement AiEstimatorService**
Angular service for all HTTP calls to AI endpoints. Injects session ID from existing auth service.

**Sub-task 1.2.2 — Implement EstimatorFormComponent**
Free-text input + submit. Calls `AiEstimatorService.estimate(query)`. Loading state during request.

**Sub-task 1.2.3 — Implement CostResultsCardComponent**
Four-element layout: headline range, three-cell data row, explanation, footnote. Active-parameter chips. Confidence badge (see Epic 2). Mobile-first: single column at <768px.

**Sub-task 1.2.QA — QA: results card**
`qa-subtask`
**AC:**
1. All four elements render correctly.
2. Active-parameter chips show current params and update on follow-up.
3. iOS Safari + Android Chrome: no horizontal overflow, data row stacks vertically at <768px.
4. Roofer session: `CostResultsCardComponent` never instantiated; finance data never in bindings.
5. `outOfScope: true` response renders redirect message, not empty card.

---

## Epic 2 — Confidence & Transparency

### US 2.1 — Confidence tier badge and geographic widening

**Sub-task 2.1.1 — Implement confidence tier logic**
HIGH if `matchCount >= 15`; MODERATE if `5 <= matchCount < 15`; LOW if `matchCount < 5` after full widening. Pass `confidenceTier` and `geoWidened` to Context Builder.

**Sub-task 2.1.2 — Render confidence badge**
HIGH (green), MODERATE (amber), LOW (red). Non-dismissible. LOW badge text: "LOW CONFIDENCE — estimate based on broader dataset".

**Sub-task 2.1.QA — QA: confidence tier**
`qa-subtask`
**AC:**
1. ≥15 matches → HIGH badge, no widening note.
2. 5–14 matches → MODERATE badge; if widened, footnote shows widened scope.
3. Narrow query → geo widening → LOW CONFIDENCE badge with correct text.
4. LOW badge never absent when `matchCount < 5` — verified on every LOW path test.
5. `bid_year` filter never widened — verified by inspecting Data Graph API payloads.

---

## Epic 3 — Multi-Turn Refinement

### US 3.1 — In-session query refinement

**Sub-task 3.1.1 — Implement Session Context Store**
`Map<sessionId, SessionEntry>`. Full-merge: new params overwrite, absent inherit. 3+ new params → silent reset. 10-turn cap. 30-minute inactivity TTL. See A3.

**Sub-task 3.1.QA — QA: multi-turn context**
`qa-subtask`
**AC:**
1. 5-scenario test: each has ≥1 follow-up changing exactly one param; all others retained.
2. 3+ simultaneous new params → session reset; chips reflect only new params.
3. 30 minutes inactivity → context expired; next query treated as new session.
4. Turn 11 → context resets; 11th query behaves as fresh session.
5. Logout/login → no prior context inherited.

---

## Epic 4 — Role-Gated Access

### US 4.1 — RBAC enforcement on all AI endpoints

**Sub-task 4.1.1 — Implement RBAC Middleware**
`rbacMiddleware(allowedRoles[])` Express middleware. Role from existing auth JWT. `users.is_admin === true` → `'super_admin'`. 403: `{ error: "Access denied", code: "INSUFFICIENT_ROLE" }`. Write unit tests: all role × endpoint combinations.

**Sub-task 4.1.2 — Implement POST /api/ai/spec route**
Spec card endpoint. Returns membrane/job type distribution + match count. Roofer only. Does not call Ratio Processor or Claude.

**Sub-task 4.1.3 — Implement SpecSummaryCardComponent**
Standalone Angular component. Membrane type + job type distribution, no finance fields. Never shares component tree or data bindings with `CostResultsCardComponent`.

**Sub-task 4.1.QA — QA: RBAC enforcement**
`qa-subtask`
**AC:**
1. Roofer → `/api/ai/estimate` via curl → HTTP 403 before any Data Graph query. Zero finance fields exposed.
2. Roofer → `/api/ai/summary/:id` → HTTP 403.
3. Building Owner → `/api/ai/spec` → HTTP 403.
4. Super Admin → all three endpoints → 200 with appropriate data.
5. `SpecSummaryCardComponent` never receives finance data bindings under any role.

---

## Epic 5 — Project Summary Generator *(conditional — ships July 25 only if project record detail view exists)*

### US 5.1 — On-demand project summary

**Sub-task 5.1.1 — Implement POST /api/ai/summary/:projectId**
Fetch project via `getProject(projectId)`. Role-filtered field set assembled before Claude prompt. Building Owner: cost + timeline + scope. Super Admin: full record. RBAC: Building Owner + Super Admin only.

**Sub-task 5.1.2 — Add ProjectSummaryPanelComponent**
"Generate Summary" button on existing project detail view. Calls `AiEstimatorService.generateSummary(projectId)`. Loading state. Finance fields suppressed for Building Owner (server-enforced upstream).

**Sub-task 5.1.QA — QA: project summary**
`qa-subtask`
**AC:**
1. Vauyani QA: 5 sample summaries reviewed and approved.
2. Building Owner summary: contains headline scope + cost range; no contractor bid details.
3. Super Admin summary: full synthesis including cost breakdown.
4. "Generate Summary" button never visible in Roofer sessions.
5. No auto-generation on page load — no Claude call without button click.

---

## Phase 1 Setup Tasks

| Task | Owner | Blocker for |
|------|-------|-------------|
| SSH access established | Brad + Vauyani | Everything |
| Server IP identified + sent to Vauyani → Shivam for whitelisting | Brad | Data Graph API (US 1.1) |
| `pm2 list` run — process name captured | Brad | Deployment |
| `.env` created + added to `.gitignore` before first commit | Brad | All Phase 2 |
| Shivam's data graph API docs reviewed | Brad | US 1.1 |
| Brad confirms: project record detail view exists? | Brad | Epic 5 scope |
| Brad confirms: PM2 single or multi-process? | Brad | US 3.1 |

---

## Task Count

| Epic | Stories | Impl sub-tasks | QA sub-tasks | Total |
|------|---------|----------------|--------------|-------|
| 1 | 2 | 7 | 2 | 11 |
| 2 | 1 | 2 | 1 | 4 |
| 3 | 1 | 1 | 1 | 3 |
| 4 | 1 | 3 | 1 | 5 |
| 5 | 1 | 2 | 1 | 4 |
| Phase 1 Setup | — | 7 | — | 7 |
| **Total** | **6** | **22** | **6** | **34** |
