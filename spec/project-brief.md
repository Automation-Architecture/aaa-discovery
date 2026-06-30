# Project Brief: AI Roofing Cost Estimator

**Client:** Tom / RoofingProjects.com
**Website:** roofdata.report
**Date:** 2026-06-29 (v1.0)
**Prepared by:** Automation Architecture AI

---

## Problem Statement

Tom, owner of RoofingProjects.com, has accumulated 25+ years of commercial roofing project data stored in a MongoDB database behind the roofdata.report platform. The platform currently serves building owners, roofing contractors, and consultants across the United States — but the data is locked behind structured database views. Users cannot ask plain-English questions like "What does an 80-mil TPO overlay cost per square foot in Florida?" and receive a reliable, data-backed answer.

The gap is twofold. First, there is no natural language interface: users must know what to look for and navigate structured screens to find it. Second, the database stores total blended cost figures without a recorded labour/material split — meaning even technically sophisticated users cannot extract the separated cost benchmarks that contractors and building owners need for accurate project planning and competitive bidding.

The result is a data asset that is underutilised at the point where it could generate the most value: the moment a user is scoping or evaluating a commercial roofing project.

---

## Solution Overview

- **Embedded AI query layer** built directly into the existing roofdata.report Angular/Node.js application — no new framework, no new database, no new infrastructure
- **Natural language → structured API query**: user inputs a plain-English question; the Node.js backend parses intent, maps it to parameters for Shivam's authenticated data graph API, and retrieves filtered project records
- **Cost estimator** returns material cost/sqft, labour cost/sqft (derived via industry ratio split in Phase 1), combined total cost/sqft, estimated project cost range, and a plain-English explanation — all backed by real project data from 2024 to present
- **Low-confidence safeguard**: if fewer than 5 projects match the query, the system widens the filter incrementally (city → state → region) and explicitly flags that the estimate uses a broader dataset
- **Role-based access control** gates every AI endpoint: Roofer/Contractor sees specs and materials only; Building Owner/Client sees cost estimates and summaries; Super Admin (Tom) has full data visibility
- **Project summary generator** produces a 3–5 sentence plain-English summary of any individual project record on demand, with finance fields filtered by role before the summary is generated
- **Multi-turn conversation context** maintained in-memory per session — follow-up questions refine prior results without the user re-entering parameters
- **Proprietary data stays on-platform**: Claude receives only processed, aggregated query results from Node.js — never raw MongoDB documents or unfiltered API responses

---

## Goals

1. Any authenticated user can ask a plain-English roofing cost question and receive a data-backed estimate with material and labour cost per sqft within 5 seconds
2. Estimates for queries with 5+ matching projects are within 15% of known historical benchmarks
3. Role-based access is airtight — Roofer role cannot access any finance fields under any path
4. The platform is demo-ready and mobile-responsive for the Simon Property Group presentation on July 25, 2026
5. All proprietary project data remains on-platform — no raw records are transmitted to external AI services
6. The labour/material split schema is enriched going forward (Phase 2) so recorded data progressively replaces ratio estimates over time

---

## Knowledge Sources

The estimator is a **structured query + retrieval system**, not a RAG/vector search system. There is no document indexing.

| Source | Format | Treatment |
|--------|--------|----------|
| `intake_forms` collection | MongoDB (via data graph API) | Primary source — filtered, aggregated query results passed as structured context to Claude. Never raw documents. |
| `categories` collection | MongoDB (via data graph API) | Lookup table for category `_id` mapping (membrane type, job type, manufacturer, thickness) — resolved before filtering `intake_forms.selectedValues` |
| `buildings` collection | MongoDB (via data graph API) | Location join via `intake_forms.building_id` when state/city filtering needed |
| `project_size_range` collection | MongoDB (via data graph API) | Pre-defined size brackets — used as-is, no custom ranges invented |
| `winning_contractors` collection | MongoDB (via data graph API) | Contractor reference data — Super Admin only |
| `users` collection | MongoDB (via data graph API) | Role field drives RBAC middleware — `is_admin` flag for super admin gating |

**Explicitly excluded:**
- Raw MongoDB documents are never sent to Claude
- Pre-2024 project data is excluded at query layer (`bid_year >= '2024'`, string comparison)
- No external data sources, web search, or third-party pricing databases

---

## Agent / System Behavior

**Happy-path flow:**

```
User (Angular UI)
  │
  │  [plain-English question, e.g. "80-mil TPO overlay, Florida, 30,000 sqft"]
  ▼
Node.js AI Endpoint  (/api/ai/estimate)
  │
  │  [parse intent → extract: membrane type, job type, sqft, state, bid_year >= '2024']
  │  [lookup category _id from categories collection via data graph API]
  ▼
Shivam's Data Graph API  [auth: ROOFDATA_API_KEY + ROOFDATA_SECRET_KEY]
  │
  │  [returns matching intake_forms records — filtered, aggregated]
  ▼
Node.js Processing Layer
  │
  │  [apply labour/material ratio split based on job type:
  │    overlay: 35% labour / 65% material
  │    full tear-off: 45% labour / 55% material
  │    repair: 50% labour / 50% material]
  │  [compute: total cost/sqft, project cost range low-high, match count]
  ▼
Claude API  (claude-sonnet-4-6, max 1,000 tokens)
  │
  │  [structured context only — no raw records]
  │  [returns: material $/sqft, labour $/sqft, combined $/sqft, range, explanation]
  ▼
Angular Results Card  (mobile-responsive)
```

---

## Success Metrics

| Metric | Target | Measurement method |
|--------|--------|--------------------|
| Estimator accuracy | Within 15% of known historical benchmarks | Manual comparison — 10 varied inputs against known project data (Phase 5) |
| Response time | Under 5 seconds end-to-end | 10-concurrent-query load test (Phase 5) |
| RBAC enforcement | 0 finance field exposures for Roofer role | Login as roofer, attempt finance queries across all endpoints (Phase 4) |
| Multi-turn context | 5/5 follow-up queries correctly refine prior context | Manual 5-scenario test (Phase 5) |
| Mobile rendering | No layout breakage on iOS Safari + Android Chrome | Manual device tests (Phase 3) |
| Data privacy | 0 raw MongoDB documents in Claude API payloads | Inspect Node.js → Claude API request bodies (Phase 2) |
| Project summary quality | Summaries pass Vauyani QA for 5 sample projects | Vauyani manual review (Phase 3) |
| Low-confidence warning | Warning displayed on every query with < 5 matches | Forced narrow-query test (Phase 2) |

---

## Scope

### Phase 1 — Data Audit, Environment Setup & IP Registration (June 23–30)
- Server SSH access established (Brad generates key pair, Vauyani adds to `authorized_keys`)
- Server IP of roofdata.report identified and sent to Vauyani → Shivam for whitelisting (**blocker**)
- PM2 process name identified (`pm2 list`)
- `.env` created with `ANTHROPIC_API_KEY`, `ROOFDATA_API_KEY`, `ROOFDATA_SECRET_KEY` — added to `.gitignore` before first commit

### Phase 2 — Claude API Integration & Query Engine (July 1–11)
- Claude API integration (Node.js backend only)
- Natural language query engine: intent parsing → category `_id` lookup → data graph API call
- Labour/material ratio split logic applied in Node.js layer
- No raw data sent to Claude API (verified via payload inspection)

### Phase 3 — Angular UI Components (July 7–16)
- Estimator form component
- Results card component (material $/sqft, labour $/sqft, combined, range, match count, explanation)
- Project summary panel + "Generate Summary" button
- Mobile-responsive layout (iOS Safari + Android Chrome)

### Phase 4 — Role-Based Access & Security (July 14–18)
- RBAC middleware on all AI endpoints (Node.js)
- Angular frontend reflects role (no finance fields rendered for Roofer)

### Phase 5 — Testing, QA & Demo Prep (July 19–25)
- 10-input manual accuracy test
- 10-concurrent-query load test
- RBAC penetration test
- Multi-turn context 5-scenario test
- Mobile device testing
- Final demo walkthrough with Vauyani on July 24

### Out of Scope (v1)
- Changes to existing MongoDB schema or any existing application features
- Rebuilding the user authentication system
- Payment processing or marketplace features
- Training or fine-tuning any AI model
- Persistent conversation history across user sessions

---

## Stakeholders

| Name | Role |
|------|------|
| Tom | Client / Product Owner |
| Vauyani Bailey | Project Lead (Black Sigma) |
| Brad | Full-Stack Developer |
| Shivam | DB Reference (Phase 1 only) |

---

## High-Level Architecture

| Layer | Choice | Notes |
|-------|--------|-------|
| Frontend | Angular (existing) | New estimator form, results card, project summary panel |
| Backend | Node.js / Express (existing) | New API routes added to existing Express server |
| Data access | Shivam's data graph API | Authenticated REST API in front of MongoDB |
| Database | MongoDB (existing) | Read-only via data graph API |
| AI | Claude API — `claude-sonnet-4-6` | Called from Node.js backend only — max 1,000 tokens per response |
| Auth | Existing auth system | Role middleware extended to gate AI endpoints |
| Deploy | On-premises Linux / PM2 | SSH deployment |
| Reverse proxy | Nginx or Apache (existing) | Confirm setup with Vauyani before any config changes |

### Module Breakdown

1. **Query Intent Parser** — extracts structured parameters from plain-English user input
2. **Category ID Resolver** — looks up `_id` values from the `categories` collection
3. **Data Graph API Client** — authenticated HTTP client for Shivam's API
4. **Labour/Material Ratio Processor** — applies job-type-specific industry ratios
5. **Claude Context Builder** — assembles structured context payload for Claude API
6. **RBAC Middleware** — enforces role-based access at the Node.js endpoint layer
7. **Session Context Store** — maintains in-memory per-session conversation state
8. **Angular Estimator UI** — estimator form, results card, project summary panel

---

## Open Items Pending Client Input

1. Tom's contact email
2. Server IP whitelisting confirmation from Shivam (Phase 1 Day 1 blocker)
3. SSH access grant from Vauyani
4. Data graph API documentation from Shivam
5. API credentials delivery (`ROOFDATA_API_KEY`, `ROOFDATA_SECRET_KEY`)
6. Repository location and branch strategy
7. Staging environment decision
8. Phase 1 sign-off
9. System prompt refinement

---

## Discovery Phase Status

| # | Step | Status |
|---|------|--------|
| 1 | Read sales call transcript | ✅ Done |
| 2 | Read signed proposal | ✅ Done |
| 3 | Write project brief | ✅ Done |
| 4 | Autonomous product scope grill | ✅ Done |
| 5 | Write PRD | ✅ Done |
| 6 | Create Jira board + epics | ⚠️ Pending Vauyani |
| 7 | Architecture grill (engineer-led) | ✅ Done (stub staged) |
| 8 | Write tech spec | ✅ Done |
| 9 | Discovery eval (quality gate) | ✅ Done |
| 10 | Populate Jira tasks | ✅ Done |
| 11 | Client dashboard | ⚠️ Run /aaa-client-init locally |
| 12 | Verify DOCX deliverables in Drive | ⚠️ Generate locally with pandoc |
| 13 | Discovery digest to #po | ✅ Draft ready |
