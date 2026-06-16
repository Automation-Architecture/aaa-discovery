# Step 5 — Write the PRD

## Goal

A focused Product Requirements Document that captures the problem, the solution, and the work broken into Epics. An **Epic** is a complete, user-facing feature the user can see and get value from — not a technical layer, not a module, not a task. If a user cannot open it, use it, and walk away with something useful, it is not an Epic.

The PRD does not go into user stories, sub-tasks, API contracts, or data model detail — those belong in the tech spec (step 9) and the Jira board (step 10).

## How to invoke

Use the Skill tool with `to-prd`, explicitly pointing it at the brief and the locked decisions:

```python
Skill(skill="to-prd", args={
  "brief": "spec/project-brief.md",
  "decisions": "spec/GRILL_SESSION.md",
  "structure": "overview, problem-statement, objectives, solution, epics"
})
```

The skill reads both files and synthesizes. It does not rely on conversation context — the brief and `GRILL_SESSION.md` are the authoritative inputs.

## Where it lives

`spec/prd.md` (v1.0) in the project repo.

## Structure

```markdown
# PRD: <Client Project Name>

**Version:** 1.0
**Date:** <YYYY-MM-DD>
**Status:** Draft
**Source:** `spec/project-brief.md` + `spec/GRILL_SESSION.md`
**Companion docs:** `spec/project-brief.md`, `spec/tech-spec.md`

---

## Overview

Two to three sentences. What the system is, who it is for, and what
it replaces or improves.

---

## Problem Statement

What is broken, underused, or under-leveraged today. Plain language,
2–3 paragraphs. This must match the brief's Problem Statement — do not
rewrite it, summarise it.

---

## Objectives

Four numbered, measurable outcomes the system must achieve. Each
objective should be testable — a reviewer must be able to confirm
whether it was met.

1. <Objective 1>
2. <Objective 2>
3. <Objective 3>
4. <Objective 4>

---

## Solution

What we are building and how it addresses the problem. 4–8 bullets
describing the system's character and key capabilities from the user's
perspective. Do not go into architecture — that is for the tech spec.

---

## Module Breakdown

The major independently-testable components of the system. Derived from
the brief and grill session — there is no codebase to inspect at this
stage. Aim for deep modules: each encapsulates a significant chunk of
functionality behind a simple, stable interface.

| Module | Responsibility | Interface |
|--------|---------------|-----------|
| <Module name> | <One sentence: what it owns end-to-end> | In: <input> → Out: <output> |
| ... | ... | ... |

---

## Epics

Each Epic is a complete, user-facing feature the user can see and get
value from. A user must be able to open it, use it, and walk away with
something useful. If a feature is invisible to the user or only serves
a technical purpose, it is not an Epic here — it belongs in the tech
spec as an implementation concern.

> **Epic shape standard:** Before writing Epics, read
> `aaa-SOP/discovery-sop.md §2 — Epic Scope Standard`. The SOP defines
> what makes a valid feature epic, the named exceptions (enabler epics,
> compliance/external-gate epics), and the ratio check. Epics that don't
> meet the standard must be restructured before the PRD is committed.

Epics should map to the modules above — an Epic typically combines one
or more modules into a user-facing workflow.

| # | Epic | What the user can do | Value delivered |
|---|------|----------------------|-----------------|
| 1 | <Epic name> | <User action> | <Outcome> |
| 2 | ... | ... | ... |

For each Epic, add a short paragraph below the table describing its
scope boundary — what is in and what is explicitly not in this Epic.
```

## After `/to-prd` finishes

1. Check the output for:
   - Financial info → remove (global rule)
   - Each Epic passes the usability test: can a user open it, use it, and get value from it?
   - Objectives are measurable (not vague aspirations)
   - Problem Statement matches the brief
2. Commit `spec/prd.md` to git
3. Generate the DOCX and upload to Drive:
   ```bash
   # Generate locally
   pandoc spec/prd.md \
     -o /tmp/<slug>-PRD-v1.0.docx \
     --from markdown --to docx
   ```
   Then upload via Google Drive MCP:
   - Target: Onboarding Shared Drive (`0AOk2FIY4h-9gUk9PVA`) → `<Client Full Business Name>/deliverables/`
   - Use `mcp__claude_ai_Google_Drive__create_file` with the local file path and the client deliverables folder ID
   - Filename: `<Client>-<Project>-PRD-v1.0.docx`

## Don't do this

- **Don't include user stories, sub-tasks, or acceptance criteria.** Those belong in the Jira board (step 10), not the PRD.
- **Don't include technical Epics** (e.g., "Database schema", "API layer", "Infrastructure setup"). If a user cannot interact with it and get value, it is not an Epic in this document — put it in the tech spec.
- **Don't paste financial info into the PRD.** Same global rule as the brief.
- **Don't re-litigate decisions.** If `spec/GRILL_SESSION.md` decided something, the PRD records it and moves on.
- **Don't contradict the brief.** If scope differs, reconcile the brief first, then write the PRD.

## Done when

PRD is written and committed, DOCX generated to `Client Docs/`, no financial info, every Epic passes the usability test, Objectives are measurable. Move to step 6.
