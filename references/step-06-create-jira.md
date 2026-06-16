# Step 6 — Create Jira space + empty board

## Goal

Create the Jira project for the client engagement and populate it with epics from the PRD. Epics are created here in step 6 from the PRD; tasks are added later in step 10 after the tech spec is written. The project key also needs to exist now because the dashboard sync workflow (step 11) references it.

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
- The brief's deliverables sequence row for step 6 (status → ✅ Done with the key + board number)
- Memory for the project so future sessions can find it

## Assign the engineer

Before moving to step 7, the assigned engineer must be known. Step 7 sends them a direct `#po` notification and stages their architecture grill — running it without a named engineer produces decisions no one is accountable for.

Ask the PO now:

> Who is the assigned engineer for this project? I need their name and Slack user ID (format: `@USERID`) so I can notify them in step 7.

Save both to project memory:

- **Engineer name** (e.g., "Brad")
- **Engineer Slack user ID** (e.g., `U12345678`)

If the engineer hasn't been assigned yet, **stop here** and ask the operator to assign one before proceeding. Do not move to step 7 without a named engineer.

## Create epics from the PRD (board-nanny Phase 1)

With the Jira project live and the engineer assigned, invoke board-nanny Phase 1 to create the epics from the PRD:

```
Agent({
  description: "Board-nanny Phase 1: draft epics for <Project>",
  subagent_type: "board-nanny",
  prompt: "Read spec/prd.md Epics section. Jira project: <KEY>, board: <NN>. Create epics only — no tasks yet. Assign each epic to <engineer-name>. Draft for operator review before writing to Jira."
})
```

Review the epic draft against `aaa-SOP/discovery-sop.md §2 — Epic Scope Standard`. Approve, then the agent writes the epics to Jira via the Atlassian MCP. Each epic should have the assigned engineer set.

## Notify engineer and Brad

Once epics are live in Jira, send a single message to `#po` (channel ID `C0B9AE6JQUR`) via `mcp__claude_ai_Slack__slack_send_message`. Send directly — no draft needed.

The message must include:

- Tag the engineer (`<@engineer-userid>`)
- Jira board link: `https://automationarchitecture.atlassian.net/jira/software/projects/<KEY>/boards/<NN>`
- GitHub repo link: `https://github.com/Automation-Architecture/<slug>`
- Instruction: review your assigned epics on Jira, then pull the GitHub repo — the architecture grill stub will be committed there shortly and you'll be tagged when it's ready
- Tag Brad (`<@Brad-userid>`) with: please add `<engineer-name>` as a collaborator on `Automation-Architecture/<slug>` so they can access the grill session file

## Verify engineer has GitHub repo access

After sending the Slack message, confirm the engineer has been added as a collaborator. Brad adds them via GitHub UI — check that it took:

```bash
gh api repos/Automation-Architecture/<slug>/collaborators --jq '.[].login'
```

The engineer's GitHub handle must appear before step 7 Phase B begins. If it doesn't, ping Brad in `#po`. The engineer cannot pull the repo and fill in the grill session without it.

## End of step: PR to GitHub

Commit any discovery tracking or config files produced in this step (e.g., updated `spec/project-brief.md` discovery phase table) and open a PR:

```bash
git checkout -b discovery/step-06-jira-setup
git add spec/
git commit -m "docs(step-06): Jira project created, epics drafted"
git push -u origin discovery/step-06-jira-setup
gh pr create --title "Step 6: Jira setup + epics" --body "Jira project <KEY> created. Epics drafted from PRD. Engineer assigned."
aaa-merge <PR#>
```

## Don't do this

- **Don't pick the project key without operator approval.** They may have a preferred convention or may need to align with a parent client project.
- **Don't try to populate tasks now.** Tasks come in step 10 after the tech spec is written.
- **Don't assume the key the operator suggested initially is the final key.** If the key changes after this step, sweep all references (memory, dashboard sync workflow, DOCX filenames, email draft attachments, etc.).
- **Don't send the Slack message before epics exist in Jira.** The engineer needs actual cards to review, not a heads-up that cards are coming.

## Verify before moving on

- Project key captured and recorded
- Empty board exists at the URL
- Captured key matches what the operator confirmed
- Engineer name and Slack user ID saved to project memory
- Epics created in Jira and assigned to engineer
- Slack message sent to `#po` tagging engineer and Brad
- Brad notified to add engineer to GitHub repo

## Done when

Jira project live, epics created and assigned, Slack sent, Brad notified. PR merged to GitHub. Move to step 7.
