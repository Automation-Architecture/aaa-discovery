# Step 9 — Populate Jira tasks (board-nanny Phase 2)

## Goal

Break the approved tech spec into tasks under the existing Jira epics. The epics were created in step 6 from the PRD and are already assigned to the engineer — this step adds User Stories and sub-tasks beneath them.

> **Epics already exist.** board-nanny Phase 1 (creating epics from the PRD) ran in step 6. Do not re-run Phase 1 here — that would create duplicate epics. This step is Phase 2 only: tasks under the epics that are already on the board.

## How to invoke

Use the `board-nanny` agent:

```
Agent({
  description: "Board-nanny Phase 2: draft tasks for <Project>",
  subagent_type: "board-nanny",
  prompt: "Epics are already live in Jira from step 6. Tech spec is at spec/tech-spec.md. Jira project: <KEY>, board: <NN>, cloudId: automationarchitecture.atlassian.net. Begin Phase 2 only — draft tasks (User Stories + sub-tasks) under the existing epics for operator review. Do not re-create epics. Do not write to Jira yet."
})
```

## Phase 2 — Tasks

The agent will:

1. Read the tech spec and the existing epic list from Jira
2. Break each epic into User Stories and sub-tasks using the three-level hierarchy from `aaa-SOP/discovery-sop.md §3`:

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

3. Output a markdown draft for the operator to review
4. Wait for explicit approval before writing to Jira

## Mandatory ticket content (from discovery-sop.md §3)

| Level | User Story statement | Description | Acceptance Criteria |
|---|---|---|---|
| Epic | — | ✓ required | — |
| User Story | ✓ required | ✓ required | — |
| Sub-task (implementation) | — | ✓ required | — |
| Sub-task (QA — required) | — | ✓ required | ✓ required (≥3 criteria) |

If the agent is short of detail to fill any required field, it must pause and ask rather than create a stub. This is non-negotiable.

## Phase 3 — Write to Jira

After tasks are operator-approved:

```
SendMessage to the same agent ID:
"Tasks approved, write to Jira."
```

The agent uses the Atlassian MCP to create issues with the right linkages (User Stories under Epics, sub-tasks under User Stories).

## Don't do this

- **Don't re-run Phase 1.** Epics already exist from step 6. Re-running Phase 1 creates duplicates.
- **Don't let the agent skip the approval gate.** The task draft must be reviewed before anything is written to Jira.
- **Don't put financial info in tickets.** Same global rule as all technical documents.
- **Don't create stub tickets.** All required fields on every card. If the agent can't write them, it pauses.
- **Don't put AC on User Stories.** AC lives on the QA sub-task only.

## Verify before moving on

- Jira board shows tasks under each existing epic (no new top-level epics were created)
- Each epic has its child User Stories and sub-tasks
- Spot-check 3 User Stories: each has a Story statement + Description, no AC
- Spot-check their QA sub-tasks: each has AC with ≥3 verifiable criteria
- Dependencies are noted in Description fields

## Done when

Board is populated with tasks, operator has approved. Move to step 10.
