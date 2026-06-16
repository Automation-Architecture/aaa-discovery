---
name: aaa-discovery
description: Walks the operator through the Automation Architecture (AAA) Discovery Phase for a new client engagement — a 13-step sequence that produces a fully scoped, ticketed, and client-informed project before any engineer writes code. Trigger this skill whenever a new client project is starting, when the operator says "kick off discovery", "start a new client", "new client engagement", "spin up a new project", "let's begin discovery", or invokes `/aaa-discovery`. Also trigger when a sales call transcript has just been read and the next step is to start scoping the work, or when the operator references "the 13 steps", "the AAA discovery flow", or "the canonical sequence". This skill orchestrates other skills (grill-me, to-prd, aaa-client-init) and agents (cto-technical-architect, board-nanny) — invoke it as the entry point so the steps run in the right order, with the right artifacts, in the right places.
---

# AAA Discovery Phase

## What this skill does

Discovery is the AAA workflow that turns a sales conversation into a fully ticketed, client-informed project ready for engineers to build against. It is **12 sequential steps**, run end-to-end, before any code is written. The skill:

- Tracks progress through the 13 steps using the operator's task list
- Hands off to other skills (`/grill-me`, `/to-prd`, `/aaa-client-init`) and agents (`cto-technical-architect`, `board-nanny`) at the right moments
- Enforces output-location conventions (markdown in repo, DOCX in Onboarding Shared Drive, no financial info in tech docs)
- Catches the order-dependent gotchas that bit the first project that ran this flow (project-key changes, version bumps, draft refreshes)

The phase ends with the work fully scoped, all tickets created, the client dashboard live, all spec DOCX deliverables uploaded to the Onboarding Shared Drive, and a discovery digest posted to `#po`. **Build Phase** (engineers writing code) only begins after step 13.

## Throughput target

**48 hours from Brad's kickoff Slack message to step-12 complete.** This is the number every run is measured against. The main external dependency is step 7 (engineer-led architecture grill ≤ 16 hours from `#po` notification → engineer fills last `Decision.` line). If that holds, the rest fits comfortably. Slip past 72 hours end-to-end → mandatory post-mortem in `docs/throughput-log.md`. Full target rationale, slip signals, and tracking method live in `docs/why.md`.

## How discovery is triggered

Discovery does not start inside this skill — it starts when **Brad** completes three pre-discovery actions:

1. **Creates the GitHub repo** under `Automation-Architecture/<slug>` (private, with README). The repo must exist before Elsa runs step 1.
2. **Uploads the signed proposal** to the Onboarding Shared Drive (`0AOk2FIY4h-9gUk9PVA`) under `<Client Full Business Name>/proposal/`.
3. **Sends a Slack message to `#po`** tagging Elsa with the client name, slug, repo URL, and a note that the 48-hour clock has started.

That Slack message is the trigger. When Elsa receives it, she runs `/aaa-discovery` in Claude Code and the 13-step sequence begins.

## When to invoke

Use this skill as the entry point any time Elsa starts a new client engagement — when the kickoff Slack message has been received and the 48-hour clock is running. Don't try to do Discovery freehand — the canonical sequence catches things ad-hoc work misses.

## What you need from the operator at kickoff

Gather these before starting Step 1. Many will be visible in the sales call transcript, but ask if not.

- **Client business name** (full, used in Drive and Jira paths) — e.g., "Kidneyhood"
- **Client primary contact** (name + email) — e.g., "Lee Hull, l.hull@kidneyhood.org"
- **Project name** — what we'll call this engagement — e.g., "Zendesk AI Agent"
- **Slug** — kebab-case, used for repo + dashboard + Jira workflow — e.g., "kidneyhood-zendesk-agent"
- **GitHub repo URL** — Brad created it before sending the kickoff message
- **Project sprint channel: `#<slug>-sprint`** — referenced in the step-7 engineer notification. Confirm it exists before reaching step 7.
- **Assigned engineer** — name + Slack user ID. Must be known by step 7.
- **Sales call transcript pointer** — Fireflies URL, Granola meeting ID, or path under `docs/client-comms/`

If anything is unclear, ask before starting. Don't infer slugs or short names — they end up baked into URLs, Jira keys, and dashboard routes.

## The 12 steps

Each step has a dedicated reference file under `references/step-NN-<name>.md` with the full playbook. SKILL.md gives the overview and delegation points; the reference files have the commands, the file paths, the gotchas, and the verification checks.

| # | Step | Reference | Output |
|---|------|-----------|--------|
| 1 | Read sales call meeting transcripts | `references/step-01-read-transcripts.md` | Internal context, no artifact |
| 2 | Read the signed proposal (formal scope + deliverables) | `references/step-02-read-proposal.md` | Internal context, no artifact |
| 3 | Write the project brief | `references/step-03-write-brief.md` | `spec/project-brief.md` (v1.0) |
| 4 | `/grill-me` on the project brief | `references/step-04-grill-me-brief.md` | Locked-in product decisions |
| 5 | Write the PRD via `/to-prd` | `references/step-05-write-prd.md` | `spec/prd.md` (v1.0) |
| 6 | Create Jira space + empty board | `references/step-06-create-jira.md` | Jira project + board |
| 7 | Notify engineer via `#po` and stage architecture grill stub (**engineer-led**) | `references/step-07-grill-me-arch.md` | Slack message sent to `#po`; `spec/GRILL_SESSION.md` Round 2 stub committed |
| 8 | Write tech spec | `references/step-08-tech-spec.md` | `spec/tech-spec.md` |
| 9 | Populate Jira board with Epics + Tasks (`board-nanny`) | `references/step-09-board-nanny.md` | Tickets created |
| 10 | Create client dashboard entry (`/aaa-client-init`) | `references/step-10-client-dashboard.md` | Dashboard PR merged |
| 11 | Generate spec DOCX deliverables and upload to Drive | `references/step-11-spec-docx.md` | Brief, PRD, Tech Spec DOCX in Onboarding Shared Drive `<Client>/deliverables/` |
| 12 | Post discovery digest to `#po` | `references/step-12-discovery-digest.md` | Slack message in `#po` with all 12 steps + artifact links |

## Progress tracking

Add the 13 steps to the task list at kickoff so the operator can see where they are. Mark each step `in_progress` when you start it and `completed` as soon as it lands — don't batch.

## Output-location conventions (non-negotiable)

These match the operator's global rules. Reread them periodically; the temptation to drop files in the wrong place is real.

- **Markdown source of truth** lives in the project's repo at `spec/`. Examples: `spec/project-brief.md`, `spec/prd.md`, `spec/tech-spec.md`.
- **Pre-Discovery artifacts — transcripts** (sales call recordings): search via Fireflies MCP using business name + attendee name. Read in step 1.
- **Pre-Discovery artifacts — signed proposal** lives in the **Onboarding Shared Drive** on Google Drive (Drive ID: `0AOk2FIY4h-9gUk9PVA`), under `<Client Full Business Name>/proposal/`. Read via the Google Drive MCP in step 2.
- **DOCX deliverables** are generated via pandoc to `/tmp/` and uploaded to the Onboarding Shared Drive under `<Client Full Business Name>/deliverables/` using the Google Drive MCP. Never generate a DOCX into the repo. If you find a DOCX in the repo, `git rm` it.
- **Memory** for the project lives at `~/.claude/projects/-Users-brad-Documents-aaa-client-projects/memory/`.
- **No financial information in any technical doc** — no budget, no pricing, no payment status, no proposal terms. That belongs in the Onboarding Shared Drive proposal folder and the sales conversation only.
- **GitHub repos** go under the `Automation-Architecture` org — Brad creates the repo before discovery starts.

## Tools and skills used across the 13 steps

| Tool / skill / agent | Steps where used |
|----------------------|------------------|
| Fireflies MCP, Granola MCP | 1 |
| Google Drive MCP (`search_files`, `read_file_content`, `create_file`) | 2, 11 |
| Markdown drafting | 3, 5, 8, 10 |
| `/grill-me` skill | 4 |
| `/to-prd` skill | 5 |
| Atlassian MCP (Jira) | 6, 9 |
| Slack MCP | 7 (notify engineer via `#po`) |
| `cto-technical-architect` agent | 8 |
| `board-nanny` agent | 9 |
| `/aaa-client-init` skill | 10 |
| `pandoc` + Google Drive MCP | 11 |
| Slack MCP (digest) | 12 |

## Phase boundary

Discovery ends after step 13 (the `#po` digest is sent). **Build Phase** then takes over with three high-level steps: Phase 1 build (supervised), burn-in period, Phase 2 launch (autonomous + any remaining channels). Do not roll Build steps into this skill — they're not part of Discovery and they're project-specific.

## Common pitfalls (from the first run of this flow)

These are the things that went sideways on the Kidneyhood Zendesk Agent project. Heads-up so you don't repeat them.

1. **Project key churn.** The operator may recreate the Jira project under a new key after step 6 (e.g., `KZA` → `KHZ`). When this happens, sweep the codebase + memory + sync workflow + DOCX for stale references. The sweep is non-trivial — keep a checklist.
2. **DOCX path discipline.** Each document's DOCX is generated inline — brief at step 3, PRD at step 5, tech spec at step 8 — and uploaded to Drive immediately. Step 12 verifies all three are present before the digest. Pandoc writes to `/tmp/` and the Drive MCP uploads to the Onboarding Shared Drive. Never put a DOCX in the repo. All DOCX deliverables are current before the step 13 digest goes out.
3. **`/grill-me` is two rounds, not one — and the second is engineer-led.** Round 1 (step 4) tests product scope. Round 2 (step 7) tests architecture and the **assigned engineer** drives. The operator stages a stub in `spec/GRILL_SESSION.md`, commits via PR, and sends a Slack message to `#po` tagging the engineer. Skipping round 2 — or running it without the engineer — means architecture defaults get made solo and re-litigated mid-build.
4. **Version bumps signal substantive changes.** PRD v1.0 → v1.1 should reflect meaningful scope changes discovered during step 7 or thereafter. PRD v1.1 → v1.2 should reflect post-tech-spec corrections. Don't bump for cosmetic edits.

## How to kick off

When this skill is invoked:

1. Confirm the kickoff inputs (client name, contact, project name, slug, GitHub repo URL, Slack channels, transcript pointer)
2. Add the 13 steps to the task list
3. Read `references/step-01-read-transcripts.md` and start step 1
4. Move sequentially. Don't run steps in parallel — the artifacts feed forward.
5. After each step, mark it complete and read the next reference file before proceeding.

If the operator wants to deviate (skip a step, run them out of order, change tooling), pause and ask before improvising. Discovery is a sequence; out-of-order work has caused rework on every project where it happened.

Begin.
