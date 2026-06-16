# Step 13 — Post discovery digest to `#po`

## Goal

Signal to the team that Discovery is complete. Send a single Slack message to `#po` that shows every step with its status, links to all key artifacts, and names the assigned engineer. This is the last action in the Discovery Phase — once it's sent, Build Phase begins.

## How to do it

Use `mcp__claude_ai_Slack__slack_send_message` — send directly to `#po` (channel ID `C0B9AE6JQUR`). No draft, no operator review needed.

## What the message should include

### Header

```
Discovery complete: <Project Name> (<slug>)
```

### Step checklist

All 13 steps with completion markers:

```
✅ 1 — Read transcripts
✅ 2 — Read proposal
✅ 3 — Project brief
✅ 4 — Product grill session
✅ 5 — PRD
✅ 6 — Jira board created (<JIRA-KEY>)
✅ 7 — Architecture grill stub → <@engineer-userid>
✅ 8 — Tech spec
✅ 9 — Discovery eval passed
✅ 10 — Board populated (N epics, M tasks)
✅ 11 — Client dashboard live
✅ 12 — DOCX deliverables uploaded to Drive
✅ 13 — This message
```

### Key artifacts

```
Repo: https://github.com/Automation-Architecture/<slug>
Jira: https://automationarchitecture.atlassian.net/jira/software/projects/<KEY>/boards
Dashboard: https://dashboard.automationarchitecture.ai/client/<slug>
DOCX: Onboarding Shared Drive → <Client Full Business Name>/deliverables/ — Brief v<X>, PRD v<X>, Tech Spec v<X>
```

### Engineer + next milestone

```
Assigned engineer: <@engineer-userid>
Next: Build Phase — <@engineer-userid> picks up the sprint board
```

### Optional: major decisions summary

If the GRILL_SESSION.md Round 2 surfaced any decisions worth calling out (non-obvious stack choices, compliance constraints, scope exclusions), add a brief bullet list. Keep it to 3–5 bullets max — the full decisions are in the repo.

## Fill in what you know

Before sending, pull the actual values:

- **Jira key** — from step 6
- **Epic/task counts** — from the board-nanny output in step 10
- **DOCX versions** — from the filenames generated in step 12
- **Engineer Slack ID** — captured at step 7

Leave nothing as a placeholder. If a value is missing, go back to the step that was supposed to produce it.

## Don't do this

- **Don't send to any channel other than `#po`.** This is an internal team digest, not a client-facing communication.
- **Don't include financial information.** No pricing, payment status, contract terms — same global rule.
- **Don't leave placeholder values.** All 13 steps are done before this message goes out; every field should be concrete.

## Done when

Message is sent to `#po`. **Discovery Phase is complete.** Build Phase begins when the assigned engineer picks up the sprint board.
