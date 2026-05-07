# Step 5 — Create Jira space + empty board

## Goal

A blank Jira project for the client engagement. The board stays empty until step 11 (`board-nanny` populates it from the tech spec) — but the project key needs to exist now because the dashboard sync workflow (step 12) and any prior automation refers to it.

## How to do it

Two paths. Pick based on operator preference:

### Path A — operator creates manually in Jira UI (most common)

This is fast and the operator usually prefers it. Tell the operator:

> Please create a new Jira project for `<Project Name>` and share the URL. The project key should be short (3–4 letters), all caps, no numbers. Suggested: `<best 3–4 letter abbreviation>`.

Wait for the operator to share the board URL like `https://automationarchitecture.atlassian.net/jira/software/c/projects/<KEY>/boards/<NN>`. Capture the project key from the URL.

### Path B — programmatic via Atlassian MCP

Use `mcp__claude_ai_Atlassian__createJiraIssue` requires a project — but creating the *project itself* via MCP isn't always available in every Atlassian instance. Confirm you have the right scopes before assuming this path.

## Capture and persist

Once the project exists, save these values for downstream use:

- **Project key** (e.g., `KHZ`)
- **Board ID** (e.g., `448`)
- **Board URL** (full URL the operator shared)

Add the project key to:
- The brief's deliverables sequence row for step 5 (status → ✅ Done with the key + board number)
- The PRD's "Sequencing / phased build" section if relevant
- Memory for the project so future sessions can find it

## Don't do this

- **Don't pick the project key without operator approval.** They may have a preferred convention or may need to align with a parent client project.
- **Don't try to populate the board now.** Step 11 does that, after the tech spec is written.
- **Don't assume the key the operator suggested initially is the final key.** On the first run of this flow, the operator changed `KZA` to `KHZ` after step 5 was already done. If the key changes after this step, sweep all references (memory, dashboard sync workflow, PRD/brief Pinecone index names if applicable, email draft attachments, etc.).

## Verify before moving on

- Project key captured and recorded
- Empty board exists at the URL
- Captured key matches what the operator confirmed (don't trust your own guess)

## Done when

Jira project + board exist, key + URL recorded, brief updated. Move to step 6.
