# aaa-discovery

A repeatable workflow for moving a closed sale to **build-ready in days, not weeks**.

## Why this exists

**Discovery is the bottleneck.** New clients are onboarding faster than discovery can hand them off, and engineering sits idle waiting for clarity. Every day a project lingers in discovery is a day the build phase doesn't start.

This workflow exists to **unblock engineering** — to graduate post-sales artifacts (transcripts, proposals, emails) into a developer-ready PRD predictably and quickly, so build can commence without delay.

Quality is the floor, not the ceiling: the PRD must still leave the engineer with a mental model as complete as the operator's. But the design constraint is **throughput** — fewer round-trips, less re-discovery, faster handoff.

## Inputs

Whatever's available — usually some subset of:

- **Meeting transcripts** (Fireflies, Granola, Zoom)
- **Sales proposal** (full doc or just the scope section)
- **Email threads** with the prospect/client
- **Operator's head** — the gaps the artifacts don't fill

Discovery proceeds even when inputs are sparse. Sparse inputs just mean more grilling.

## Process

1. **Ingest** — pull together the available transcripts, proposal text, and any other context.
2. **Project brief** — produce a short, structured brief from those inputs (problem, audience, scope, constraints, knowns, unknowns).
3. **Grill** — invoke the `grill-me` skill. Interrogate the operator branch by branch until every meaningful decision is resolved. This is non-negotiable; the brief is never enough on its own.
4. **PRD** — invoke the PRD-creation skill (e.g. `to-prd`) to convert the grilled, aligned context into a developer-ready PRD.
5. **Handoff** — PRD goes to engineering with enough fidelity that the engineer can start building without a re-discovery round.

## Required skills

| Skill | Role |
|---|---|
| `grill-me` | **Essential.** Resolves every branch of the decision tree by interviewing the operator until shared understanding is reached. |
| `to-prd` (or equivalent PRD-creation skill) | Converts the aligned context into a publishable PRD. |

## Artifacts produced

- `project-brief.md` — first-pass structured summary of the inputs
- `discovery-notes.md` — captured decisions and resolutions from the grilling round
- `prd.md` — the developer-ready PRD (handoff artifact)

## Goal

**Closed-sale to build-ready in days, not weeks** — without dropping below the quality floor (engineer's mental model = operator's).

If the engineer needs a re-discovery round, throughput failed. If the build starts but builds the wrong thing, the floor failed. Both are failure modes.

## Status

Early — repo just initialized. Workflow scaffolding TBD.
