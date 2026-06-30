# Tech Spec — AI Roofing Cost Estimator

> **Project:** roofdata-sprint | **PRD:** v1.0 | **Tech Spec:** v1.0 | **Date:** 2026-06-29

---

## 1. Executive Summary

Three new Node.js API routes and four new Angular components added to the existing roofdata.report platform. No new infrastructure, no new database, no new server. Backend pattern: Node.js intent parser → category `_id` lookup → data graph API → ratio split → Claude API → Angular.

Core constraints: existing Express server extended (not replaced), all AI logic in Node.js (never Angular), Claude receives only aggregated results (never raw MongoDB documents), all API keys in `.env` on server only.

---

## 2. Goals & Non-Goals

**Goals:** Three new Express routes, RBAC at Node.js middleware, in-memory session context, all Claude calls within 1,000-token budget, mobile-responsive Angular UI, <5 second response time.

**Non-Goals:** Changes to existing MongoDB schema, rebuilding authentication, staging environment, persistent conversation history, external APM.

---

## 3. System Context

```
User (Angular UI)
       │  HTTPS (existing auth)
       ▼
Express Server (Node.js — existing)
       ├── /api/ai/estimate          ← new
       ├── /api/ai/spec              ← new
       └── /api/ai/summary/:id       ← new
              │
              ├── [RBAC Middleware]
              ├── [Query Intent Parser]
              ├── [Session Context Store]
              ├── [Category ID Resolver]
              └── [Data Graph API Client] ──► Shivam's Data Graph API
                          │
              [Labour/Material Ratio Processor]
                          │
              [Claude Context Builder] ────► Anthropic Claude API
```

| Service | Auth | Credential | Where stored |
|---------|------|-----------|-------------|
| Shivam's Data Graph API | API key pair | `ROOFDATA_API_KEY` + `ROOFDATA_SECRET_KEY` | `.env` on server |
| Anthropic Claude API | Bearer | `ANTHROPIC_API_KEY` | `.env` on server |

---

## 4. Module Specifications

### Query Intent Parser
- **Interface:** `parseIntent(rawText: string): IntentResult | 'OUT_OF_SCOPE'`
- `IntentResult`: `{ membraneType?, jobType?, sqft?, state?, city?, bidYearFilter: string }`
- `bidYearFilter` always defaults to `'2024'` (string) — never a number or timestamp
- Zero roofing params extracted → return `'OUT_OF_SCOPE'`
- Prompt injection patterns logged with userId + sessionId, treated as `OUT_OF_SCOPE`

### Category ID Resolver
- **Interface:** `resolveCategory(label: string, type: string): string | null`
- In-process Map cache, 1-hour TTL (Brad to confirm — A2)
- Returns `null` if no match — caller skips filter rather than throwing

### Data Graph API Client
- **Interface:** `queryIntakeForms(params)`, `getCategories()`, `getProject(projectId)`
- Credentials injected from `process.env` per call — never logged, never cached
- `bid_year` filter always passed as string `'2024'` — never cast to Date or Number
- Geographic widening: city → state → region when `matchCount < 5`
- `AuthError` (401/403) → triggers Vauyani alert immediately

### Labour/Material Ratio Processor
- **Interface:** `applyRatioSplit(avgPerSqft: number, jobType: string): RatioResult`
- Named constants: overlay `{labour: 0.35, material: 0.65}`, full-replacement `{labour: 0.45, material: 0.55}`, repair `{labour: 0.50, material: 0.50}`
- Unknown job type → full-replacement fallback + `'(fallback ratio)'` suffix
- Invalid `avgPerSqft` (NaN, negative, zero) → throws → 422

### Claude Context Builder
- **Interface:** `buildEstimateContext(input: EstimateContextInput): ClaudeRequest`
- System prompt loaded from `prompts/estimator-system-prompt.txt` at startup (A6)
- `max_tokens: 1000` hard-coded
- `OUT_OF_SCOPE` sentinel: `if (response.trim() === 'OUT_OF_SCOPE')` → substitute static redirect message (A7)
- One retry after 30 seconds on transient Claude API failures

### RBAC Middleware
- **Interface:** `rbacMiddleware(allowedRoles: string[]): RequestHandler`
- Roles: `'roofer'`, `'building_owner'`, `'super_admin'` (from `users.is_admin` flag)
- 403 response: `{ "error": "Access denied", "code": "INSUFFICIENT_ROLE" }`
- Never reveals what role would be required

### Session Context Store
- **Interface:** `getContext(sessionId)`, `mergeContext(sessionId, newParams)`, `clearContext(sessionId)`
- Plain `Map<string, SessionEntry>` — full-merge on each turn
- 3+ simultaneous new params → silent reset
- 10-turn cap; 30-minute inactivity TTL
- PM2 multi-process safety: Brad to confirm (A3)

### Angular Estimator UI
- `CostResultsCardComponent`: headline range, three-cell data row, active-parameter chips, confidence badge, explanation, footnote
- `SpecSummaryCardComponent`: membrane/job type distribution + match count — standalone, never shares bindings with cost card
- `ProjectSummaryPanelComponent`: "Generate Summary" button on project detail view — ships only if view exists (A12)
- All HTTP calls via `AiEstimatorService` — no direct HTTP from components

---

## 5. Data Model (read contract)

### `intake_forms`
| Field | Type | Used for |
|-------|------|----------|
| `selectedValues` | Object | Category `_id` → value pairs |
| `avg_per_sqft` | Number | Input to Ratio Processor |
| `bid_year` | **String** | Filter — always string comparison: `>= '2024'` |
| `project_size_sqft` | Number | Size filter |

> **Critical invariant:** `bid_year` is a String. Never cast to Date or Number.

### `categories`
| Field | Type | Used for |
|-------|------|-----------|
| `_id` | ObjectId | ID stored in `intake_forms.selectedValues` |
| `name` | String | Human-readable label ("TPO", "overlay") |
| `type` | String | Category type ("membraneType", "jobType") |

---

## 6. API Contracts

### `POST /api/ai/estimate`
- **Auth:** `rbacMiddleware(['building_owner', 'super_admin'])`
- **Request:** `{ query: string, sessionId: string }`
- **Response (200):** `{ materialPerSqft, labourPerSqft, combinedPerSqft, projectCostRangeLow, projectCostRangeHigh, matchCount, confidenceTier, geoWidened, geoScope, yearRange, ratioSource, activeParams, explanation, footnote }`
- **Errors:** 400 (bad/OOS query), 403 (Roofer), 422 (insufficient data), 503 (API unavailable)

### `POST /api/ai/spec`
- **Auth:** `rbacMiddleware(['roofer'])`
- **Response (200):** `{ matchCount, membraneDistribution, jobTypeDistribution, geoScope, yearRange, confidenceTier }`

### `POST /api/ai/summary/:projectId`
- **Auth:** `rbacMiddleware(['building_owner', 'super_admin'])`
- **Response (200):** `{ summary, role, projectId }`

---

## 7. Key Flows

### Cost estimate (happy path)
```
User → /api/ai/estimate → RBAC → Intent Parser → Session Context merge
     → Category ID Resolver → Data Graph API (+ geo widening if <5 matches)
     → Ratio Processor → Context Builder → Claude API → 200 EstimateResponse
```

### Out-of-scope query
```
User → /api/ai/estimate → Intent Parser returns OUT_OF_SCOPE
     → 400 { outOfScope: true, message: "..." }
     [No Data Graph API call, no Claude API call]
```

---

## 8. Concrete Tech Choices

| Layer | Choice | Source |
|-------|--------|--------|
| Backend runtime | Node.js (existing) | Existing |
| Web framework | Express.js (existing) | Existing |
| LLM | claude-sonnet-4-6, max 1,000 tokens | Brief + PRD |
| Frontend | Angular (existing) | Existing |
| Database access | Shivam's Data Graph API (REST) | Brief |
| Deploy | On-premises Linux / PM2 | Brief |
| HTTP client | Brad to confirm (A4) | Round 2 |
| Session store | Map (single) or Redis (multi) — Brad to confirm (A3) | Round 2 |
| Logging | Extend existing — Brad to confirm (A8) | Round 2 |
| Angular module strategy | `AiEstimatorModule` or standalone — Brad to confirm (A10) | Round 2 |
| System prompt | `prompts/estimator-system-prompt.txt` | Round 2 A6 |
| Secret management | `.env` on server — never in VCS | Brief |

---

## 9. Deployment

1. Brad SSHs to roofdata.report server
2. `git pull` on production branch
3. `npm install` if `package.json` changed
4. `pm2 restart [process-name]`
5. Verify endpoint health manually

`.env` placed manually by Brad before Phase 2. `ANTHROPIC_API_KEY`, `ROOFDATA_API_KEY`, `ROOFDATA_SECRET_KEY`. Brad adds `.env` to `.gitignore` before first commit.

---

## 10. Testing Strategy

**Automated (Phases 2–4):**
- `LabourMaterialRatioProcessor` — unit tests: all three job types + fallback + invalid input
- `RbacMiddleware` — unit tests: all role × endpoint combinations

**Manual (Phase 5, July 19–25):**
- 10-input accuracy test, 10-concurrent load test, RBAC pen test, 5-scenario multi-turn test, mobile QA, LOW CONFIDENCE path, OUT_OF_SCOPE path

---

## 11. Observability

Structured JSON logs for every AI call: `{ ts, userId, sessionId, endpoint, queryParams, confidenceTier, matchCount, geoWidened, responseMs, claudeTokensUsed }`

Every failure: `{ ts, userId, sessionId, endpoint, failureType, httpStatus, layer }`

Data graph API `AuthError` → immediate Vauyani notification.

---

## 12. Security

- All AI endpoints require authentication — no public access
- RBAC enforced at Node.js middleware — Angular reflects but does not replace it
- `ANTHROPIC_API_KEY`, `ROOFDATA_API_KEY`, `ROOFDATA_SECRET_KEY` — server-side `.env` only, never in Angular, never in VCS, never logged
- Claude receives only aggregated results — never raw MongoDB documents (verified by payload inspection in Phase 2)
- No HIPAA, PCI, or SOC2 requirements in scope for v1

---

## 13. Open Decisions

| Decision | Owner | Blocker? | By |
|----------|-------|----------|----|
| HTTP client (A4) | Brad | No | Phase 2 start |
| Session store (A3) | Brad | No | Phase 2 start |
| Logging (A8) | Brad | No | Phase 2 start |
| Angular module strategy (A10) | Brad | No | Phase 3 start |
| Project record detail view (A12) | Brad | Yes for Epic 5 | Phase 2 start |
| Dual-role account policy | Vauyani + Tom | No | Before launch |
| System prompt finalisation | Vauyani | No | Before Phase 5 QA |
| Vauyani alert channel for AuthError | Brad + Vauyani | No | Phase 2 |
