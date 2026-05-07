# Step 11 — Populate Jira board with Epics + Tasks (`board-nanny`)

## Goal

Convert the tech spec into trackable work units on the empty Jira board from step 5. The `board-nanny` agent does this in two phases — Epics first (operator approves), then Tasks (operator approves). The agent does not write to Jira without explicit approval at each phase.

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
2. Group work into 6–10 Epics (foundation, ingestion, integration X, integration Y, agent core, admin/observability, etc.)
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

The agent will:
1. Break each Epic into Tasks with:
   - **User Story** ("As a <role>, I want <capability>, so that <outcome>")
   - **Description** (context, scope, dependencies)
   - **Acceptance Criteria** (testable checklist)
2. Call out dependencies between Tasks
3. Output another markdown draft for review
4. Wait for approval before writing to Jira

## Mandatory ticket structure (from the operator's global CLAUDE.md)

Every Jira card the agent creates **must** include all three of:
1. User Story (As a <role>...)
2. Description (context, scope, dependencies, decisions/options if any)
3. Acceptance Criteria (concrete, testable checklist)

If the agent is short of detail to write all three for a card, it must pause and ask rather than create a stub. This is non-negotiable.

## Phase 3 — Write to Jira

After both Epics and Tasks are operator-approved:

```
SendMessage:
"Tasks approved, write to Jira."
```

The agent uses the Atlassian MCP to create issues with the right linkages (Tasks under Epics).

## Don't do this

- **Don't let the agent skip the approval gates.** Phases 1 and 2 are operator-review gates by design. The first run of this skill had the agent stopped mid-phase-1 because the operator decided to pivot. The gate worked. Don't shortcut it.
- **Don't put financial info in tickets.** Same global rule as the docs.
- **Don't create stub tickets.** All three components (Story / Description / AC) on every card. If you can't write all three, pause.

## Verify before moving on

- Jira board has the right Epic count
- Each Epic has its child Tasks
- Spot-check 3 Tasks: do they each have Story + Description + AC?
- Dependencies are noted in Description fields

## Done when

Board is populated, operator nods at the result. Move to step 12.
