# PRD: AI Roofing Cost Estimator

**Version:** 1.0
**Date:** 2026-06-29
**Status:** Draft
**Source:** `spec/project-brief.md` + `spec/GRILL_SESSION.md`

---

## Overview

The AI Roofing Cost Estimator is a natural-language query interface embedded into the existing roofdata.report Angular/Node.js platform. It allows authenticated building owners, contractors, and consultants to ask plain-English roofing cost questions and receive data-backed estimates — broken down into material and labour cost per square foot — drawn from 25+ years of real commercial project data.

---

## Problem Statement

Tom has accumulated 25+ years of commercial roofing project data, but users cannot ask plain-English questions and receive reliable, data-backed answers. The database stores total blended cost figures without a recorded labour/material split.

---

## Objectives

1. Any authenticated Building Owner or Super Admin can ask a plain-English roofing cost question and receive a data-backed estimate within 5 seconds.
2. Role-based access is airtight — the Roofer/Contractor role cannot access any finance fields under any path.
3. The estimator is demo-ready for the Simon Property Group presentation on July 25, 2026.
4. All proprietary project data remains on-platform — zero raw MongoDB documents in Claude API payloads.

---

## Solution

- **Natural language query interface** embedded into the existing roofdata.report app
- **Three-tier confidence model** — HIGH (≥15 matches), MODERATE (5–14), LOW (<5 after full geo widening)
- **Answer-first, clarification-last** — estimate returned immediately; at most one follow-up question
- **Persistent labour/material split disclosure** — footnote on every results card
- **Multi-turn conversation context** — full-merge parameter state, 10-turn cap, no cross-session persistence
- **Role-differentiated output** — Building Owner sees cost estimate; Roofer sees spec card via separate endpoint
- **Project summary generator** — "Generate Summary" button on project record detail view
- **Two-layer off-topic defence** — Node.js classifier + Claude `OUT_OF_SCOPE` sentinel

---

## Module Breakdown

| Module | Responsibility | Interface |
|--------|---------------|-----------|
| Query Intent Parser | Extracts structured parameters; classifies off-topic queries | In: raw text → Out: params or `OUT_OF_SCOPE` |
| Category ID Resolver | Looks up `_id` values from `categories` collection | In: label → Out: MongoDB `_id` |
| Data Graph API Client | Authenticated HTTP client for Shivam's API | In: query params → Out: aggregated records |
| Labour/Material Ratio Processor | Applies job-type-specific industry ratios | In: `{avg_per_sqft, job_type}` → Out: split result |
| Claude Context Builder | Assembles Claude payload; enforces token budget; never raw docs | In: processed results → Out: Claude request |
| RBAC Middleware | Enforces role-based access at Node.js layer | In: JWT role → Out: allowed or 403 |
| Session Context Store | Full-merge parameter state; 10-turn cap | In: new params → Out: merged state |
| Angular Estimator UI | Form, cost card, spec card, summary panel; mobile-responsive | In: API response → Out: rendered card |

---

## Epics

| # | Epic | What the user can do | Value delivered |
|---|------|----------------------|-----------------|
| 1 | Cost Estimator | Ask plain-English roofing cost question → receive material/labour/combined $/sqft + range + explanation | Data-backed cost benchmark without structured screens |
| 2 | Confidence & Transparency | See match count, geo scope, confidence tier on every estimate | Informed decisions with full data quality visibility |
| 3 | Multi-Turn Refinement | Ask follow-up questions; see active parameters as chips | Iterate to precise estimate conversationally |
| 4 | Role-Gated Access | Building Owner sees cost; Roofer sees spec distribution; Super Admin sees everything | Role-appropriate data, nothing more |
| 5 | Project Summary Generator | Click "Generate Summary" on any project record → plain-English summary | Understand any project without reading raw fields |

### Epic 1 — Cost Estimator
In scope: query form, intent parsing, data graph API query, ratio split, Claude formatting, results card. Out of scope: year-range selector, custom ratio overrides.

### Epic 2 — Confidence & Transparency
In scope: three-tier badge, persistent ratio footnote, geo widening (city → state → region), LOW flag when <5 matches after full widening. Out of scope: year-range widening as fallback.

### Epic 3 — Multi-Turn Refinement
In scope: in-memory parameter state, active-parameter chips, single trailing clarification question. Out of scope: cross-session persistence, saved query history.

### Epic 4 — Role-Gated Access
In scope: RBAC at Node.js layer, `SpecSummaryCardComponent` for Roofer, Building Owner cost results, Super Admin full output. Dual-role policy deferred.

### Epic 5 — Project Summary Generator
In scope: "Generate Summary" button on project record detail view, role-filtered assembly, 3–5 sentence summary. **Ships July 25 only if project record detail view already exists in the Angular app.**

---

## Open Items

1. Tom's contact email
2. Server IP whitelisting (Phase 1 Day 1 blocker)
3. SSH access grant from Vauyani
4. Data graph API documentation from Shivam
5. API credentials (`ROOFDATA_API_KEY`, `ROOFDATA_SECRET_KEY`)
6. Repository location and branch strategy
7. Staging environment decision
8. Phase 1 sign-off
9. Project record detail view existence (determines Epic 5 scope)
10. Dual-role account policy
11. System prompt finalisation
