# Step 11 — Create client dashboard entry (`/aaa-client-init`)

## Goal

Register the new project on the AAA client dashboard so the client gets a stable URL (`https://dashboard.automationarchitecture.ai/client/<slug>`) where they can see live status — sprint progress, GitHub activity, weekly updates, document library, horizon.

The client dashboard reads from Jira (sprint data) and GitHub (activity), so step 10 needs to be complete first or there's nothing to display.

## Prerequisites

- Jira board populated (step 10) so the dashboard's sync workflow has data to pull
- GitHub repo created before discovery started (prerequisite) so the activity feed has commits
- A `project.config.yaml` in the project repo with the slug, contact channel, and other metadata

## Create `project.config.yaml`

In `~/Documents/aaa/client_projects/<initials>/repo/<project>/project.config.yaml`:

```yaml
project:
  name: "<Project Name>"
  client: "<Client first name>"
  slug: "<project-slug>"
  slack_contact_channel: ""  # not used — no client-facing Slack channel
  api_base_url: "https://<slug>.railway.app"  # placeholder until prod is up
  stage: "discovery"
  closed_stages: []
  started: "<YYYY-MM-DD>"
  target_launch: "<YYYY-MM-DD>"  # operator's best guess
  jira_project_key: "<KEY>"
  description: "<One-paragraph description from brief>"
  engagement_type: "<e.g., Project · AI Agent>"
```

## Invoke the skill

```
Skill(skill="aaa-client-init", args="<path-to-project.config.yaml>")
```

The skill (which lives in `aaa-client-dashboard/.claude/skills/aaa-client-init/`):
1. Validates the config
2. Checks the slug doesn't collide with an existing client
3. Registers the client in `app/src/app/config/clients.ts`
4. Creates the data scaffold directory `app/src/app/client/data/<slug>/` with five JSON files (`sprint-progress.json`, `weekly_updates.json`, `documents.json`, `github_activity.json`, `horizon.json`)
5. Prints the DB seed SQL to run in Railway Postgres
6. Opens a GitHub PR

## After the skill finishes

1. Review the PR diff (`gh pr view <N>`)
2. Admin-merge the PR (per the operator's global rule for low-risk additions):
   ```bash
   gh pr merge <N> --admin --squash --delete-branch
   ```
3. Add the Jira sync step for this client to `.github/workflows/sync-jira-data.yml`:
   ```yaml
   - name: Sync <Project> sprint data from Jira
     env:
       JIRA_BASE_URL: ${{ secrets.JIRA_BASE_URL }}
       JIRA_USER_EMAIL: ${{ secrets.JIRA_USER_EMAIL }}
       JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
     run: python scripts/sync_jira.py --slug <slug> --project-key <KEY>
   ```
4. Open + admin-merge that PR too
5. Trigger the workflow manually so the dashboard pulls fresh data:
   ```bash
   gh workflow run "Sync Jira Data" --repo Automation-Architecture/aaa-client-dashboard --ref main
   ```
6. Run the DB seed SQL the skill printed (or let lazy-insert handle it on first GET to `/api/projects/<slug>/stages`)

## Verify before moving on

- `https://dashboard.automationarchitecture.ai/client/<slug>` loads (after Vercel redeploys)
- Sprint data shows up after the workflow runs
- GitHub activity feed shows recent commits

## Don't do this

- **Don't skip the project.config.yaml.** The skill needs it.
- **Don't pick a slug that collides** with an existing client. The skill checks, but if the operator and the existing slug are similar, double-check.
- **Don't use the parent-client slug for a sub-project.** This project is a *new* dashboard entry (e.g., `kidneyhood-zendesk-agent`), not an update to the parent client (e.g., `kidneyhood`).

## Done when

Dashboard entry is live and the client URL loads with at least placeholder data. Move to step 12.
