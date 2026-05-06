# aaa-discovery

A workflow for graduating a closed sale into a **developer-ready PRD**.

## Why this exists

After a sale closes, engineering often inherits very little: a proposal (sometimes thin), a few meeting transcripts, and a vague mandate. The engineer ends up rebuilding context from scratch — or worse, building the wrong thing.

This workflow turns whatever post-sales artifacts exist into a structured discovery output rich enough that **the engineer building the web app understands it as well as the operator does**.

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

The engineer reading the PRD should be able to build the web app with a mental model **as complete as the operator's**. If they can't, discovery isn't done.

## Status

Early — repo just initialized. Workflow scaffolding TBD.
