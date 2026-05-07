# Step 2 — Write the project brief

## Goal

A short, scannable document (~5–10 minutes to read) that captures the problem, the proposed solution, scope, success metrics, risks, and stakeholders. The brief is the input to the first `/grill-me` round and to team feedback in step 7.

## Where it lives

`~/Documents/aaa/client_projects/<initials>/repo/<project>/spec/project-brief.md`

(If the repo doesn't exist locally yet, the operator can stage it in a temporary working directory; step 6 creates and pushes the repo. Or create it manually with `mkdir -p` and worry about git later.)

## Structure

Use this structure as a starting point. Adapt as needed for the project, but keep all the labeled sections — they all earn their place.

```markdown
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

---

## Scope

Phased if applicable (e.g., burn-in then autonomous). Each phase lists what's in scope.

### Out of Scope (v1)

Bulleted list. Be exhaustive — it's cheaper to declare something out-of-scope here than to litigate it mid-build.

---

## Stakeholders

Table: name, role.

---

## High-Level Architecture

Table: layer, choice, notes. One line per architectural concern (backend, LLM, vector DB, relational DB, deploy, eval, observability, auth, etc.). Final picks are in the tech spec; this is a sketch.

### Module Breakdown (deep, independently testable)

Numbered list of modules with one-line descriptions. Use the module concept from the operator's coding-standards skill — "deep modules with simple stable interfaces" — not shallow wrappers.

---

## Risks

Table: risk, mitigation. Include the obvious ones (the operator-facing risks: timeline, scope, compliance, budget) and the architecture risks (hallucination, latency, cost, dependencies).

---

## Open Items Pending Client Input

Numbered list of things the client needs to confirm or provide before/during build (copyright, source files, approval capacity, etc.).

---

## Discovery Phase

Reference the canonical 13-step sequence. Mark steps complete as we move through them.

| # | Step | Status |
|---|------|--------|
| 1 | Read sales call transcripts | ✅ Done |
| 2 | Write project brief | 🔄 In progress |
| ... | ... | ... |

## Build Phase

The three-step build (Phase 1 supervised, burn-in, Phase 2 launch).
```

## Don't do this

- **Do not include financial information.** No budget numbers, no pricing, no payment status, no proposal terms. That's a global rule. Tech docs are technical. Financial content belongs in `Client Docs/<Client>/proposal/`. Repeat: do not put a Budget line in the brief.
- **Do not pre-bake "open questions" you can answer.** The brief should already reflect what the operator and you know. Genuine open items go in the dedicated section; don't pad it.
- **Do not duplicate the PRD.** The brief is the 10-minute version. The PRD is the 30-minute version. If you find yourself listing 39 user stories in the brief, stop and move them to the PRD.

## Verify before moving on

- File at the correct path
- All sections present
- No financial info
- Discovery + Build phase tables included with step 1 marked done and step 2 in progress
- Module breakdown roughly matches what the architecture sketch implies

## Done when

The brief reads well end-to-end and the operator has approved it (or you've made it good enough that the operator nods at it without asking for changes). Move to step 3.
