# Project Brief: <Client Project Name>

**Client:** <First name> / <Business name>
**Website:** <client domain>
**Date:** <YYYY-MM-DD> (v1.0)
**Prepared by:** Automation Architecture AI

---

## Problem Statement

What's broken / underused / under-leveraged today, in plain language. 2–4 paragraphs.

---

## Solution Overview

What we're building. 4–8 bullets describing the system's character (autonomous, supervised-then-autonomous, integrated-into-X, closed/proprietary, etc.). Don't go into architecture — that's for the tech spec.

---

## Goals

Numbered list, 4–6 items. Each is a measurable outcome the system should achieve.

---

## Knowledge Sources

If the project has a knowledge base / RAG / data ingestion component, list every source: format, how it's treated (indexed vs few-shot vs eval-only), explicitly-rejected sources.

---

## Agent / System Behavior

ASCII flowchart of the main happy-path flow + edge cases. Annotate with notes on key decisions.

---

## Success Metrics

Table: metric, target, measurement method. ≥ 5 metrics.

| Metric | Target | Measurement method |
|--------|--------|--------------------|
| <metric> | <target> | <how to measure> |

---

## Scope

Phased if applicable (e.g., burn-in then autonomous). Each phase lists what's in scope.

### Out of Scope (v1)

Bulleted list. Be exhaustive — it's cheaper to declare something out-of-scope here than to litigate it mid-build.

---

## Stakeholders

Table: name, role.

| Name | Role |
|------|------|
| <name> | <role> |

---

## High-Level Architecture

Table: layer, choice, notes. One line per architectural concern (backend, LLM, vector DB, relational DB, deploy, eval, observability, auth, etc.). Final picks are in the tech spec; this is a sketch.

| Layer | Choice (tentative) | Notes |
|-------|--------------------|-------|
| Backend | | |
| LLM | | |
| Deploy | | |

### Module Breakdown

Numbered list of modules with one-line descriptions. Use deep modules: each encapsulates a significant chunk of functionality behind a simple, stable interface.

1. **<Module name>** — <one sentence: what it owns end-to-end>

---

## Risks

Table: risk, mitigation. Include both operator-facing risks (timeline, scope, compliance, external dependencies) and architecture risks (hallucination, latency, cost, third-party APIs).

| Risk | Mitigation |
|------|------------|
| <risk> | <mitigation> |

---

## Open Items Pending Client Input

Numbered list of things the client needs to confirm or provide before or during the build (source files, approval capacity, system access, compliance sign-offs, etc.).

---

## Compliance and External Gates

List any regulatory, compliance, or integration constraints that require external action before build can begin. Examples: HIPAA BAA with vendors, PCI scope confirmation, EHR sandbox access, OAuth app approval. Flag estimated lead times.

| Constraint | External action required | Estimated lead time |
|------------|--------------------------|---------------------|
| <e.g., HIPAA BAA with Twilio> | <vendor agreement> | <~1 week> |

---

## Discovery Phase

Reference the canonical 13-step sequence. Mark steps complete as we move through them.

| # | Step | Status |
|---|------|--------|
| 1 | Find and read the sales call transcript | ✅ Done |
| 2 | Read the signed proposal | ✅ Done |
| 3 | Write project brief | 🔄 In progress |
| 4 | Autonomous product scope grill | ⬜ |
| 5 | Write PRD | ⬜ |
| 6 | Create Jira board + epics | ⬜ |
| 7 | Architecture grill (engineer-led) | ⬜ |
| 8 | Write tech spec | ⬜ |
| 9 | Discovery eval (quality gate) | ⬜ |
| 10 | Populate Jira tasks | ⬜ |
| 11 | Client dashboard | ⬜ |
| 12 | Verify DOCX deliverables in Drive | ⬜ |
| 13 | Discovery digest to #po | ⬜ |
