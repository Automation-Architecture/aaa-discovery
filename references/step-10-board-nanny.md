# Step 10 — Populate Jira board with Epics + Tasks (`board-nanny`)

## Goal

Convert the tech spec into trackable work units on the empty Jira board from step 6. The `board-nanny` agent does this in two phases — Epics first (operator approves), then Tasks (operator approves). The agent does not write to Jira without explicit approval at each phase.

## How to invoke

Use the `board-nanny` agent:

```
Agent({
  description: "Board-nanny: draft Epics for <Project>",
  subagent_type: "board-nanny",
  prompt: "The tech spec at spec/tech-spec.md is approved. Jira project: <KEY>, board: <NN>, cloudId: automationarchitecture.atlassian.net. Begin Phase 1 — draft Epics for operator review. Do not write to Jira yet."
})
```

## Phase 1 — Epics

The agent will:
1. Read the tech spec
2. Group work into Epics

> **Epic shape standard:** Epics must conform to `aaa-SOP/discovery-sop.md §2 — Epic Scope Standard`. Each Epic must be a complete, user-facing feature that includes both its frontend and backend — not a horizontal layer (e.g., not "Frontend Build", "API Layer", "Database Schema"). Read §2 before approving the Epic draft.

3. Output a markdown draft for the operator to review
4. Wait for explicit "Epics approved, proceed to tasks" before phase 2

You and the operator review the Epic list. Common revisions:
- Merge or split Epics
- Reorder for dependency clarity
- Adjust scope where an Epic is too big or too small

## Phase 2 — Tasks

After the operator approves Epics:

```
SendMessage to the same agent ID:
"Epics approved, proceed to tasks. Same project KEY/board."
```

The agent will break each Epic into User Stories and sub-tasks using the three-level hierarchy from `aaa-SOP/discovery-sop.md §3`:

```
Epic
└── User Story  (intent: who, what, why + context)
    ├── Sub-task: <implementation unit>  (frontend, backend, etc.)
    └── Sub-task: QA  (required on every User Story — carries AC)
```

Per §3:
- **User Story** carries the `As a <role>, I want <capability>, so that <outcome>` statement and a Description (context, scope, dependencies). No AC on the User Story.
- **Acceptance Criteria live exclusively on the QA sub-task** (≥3 verifiable, testable criteria). The QA sub-task must be labelled `qa-subtask`.
- **A QA sub-task is required on every User Story** — not optional, not "add later".

The agent outputs a markdown draft for review, then waits for approval before writing to Jira.

## Mandatory ticket content (from discovery-sop.md §3)

| Level | User Story statement | Description | Acceptance Criteria |
|---|---|---|---|
| Epic | — | ✓ required | — |
| User Story | ✓ required | ✓ required | — |
| Sub-task (implementation) | — | ✓ required | — |
| Sub-task (QA — required) | — | ✓ required | ✓ required (≥3 criteria) |

If the agent is short of detail to fill any required field, it must pause and ask rather than create a stub. This is non-negotiable.

## Phase 3 — Write to Jira

After both Epics and Tasks are operator-approved:

```
SendMessage:
"Tasks approved, write to Jira."
```

The agent uses the Atlassian MCP to create issues with the right linkages (User Stories under Epics, sub-tasks under User Stories).

## Don't do this

- **Don't let the agent skip the approval gates.** Phases 1 and 2 are operator-review gates by design. The first run of this skill had the agent stopped mid-phase-1 because the operator decided to pivot. The gate worked. Don't shortcut it.
- **Don't put financial info in tickets.** Same global rule as the docs.
- **Don't create stub tickets.** All required fields on every card. If you can't write them, pause.
- **Don't put AC on User Stories.** AC lives on the QA sub-task only.

## Verify before moving on

- Jira board has the right Epic count
- Each Epic has its child User Stories and sub-tasks
- Spot-check 3 User Stories: each has a Story statement + Description, no AC
- Spot-check their QA sub-tasks: each has AC with ≥3 verifiable criteria
- Dependencies are noted in Description fields

## Done when

Board is populated, operator nods at the result. Move to step 11.
