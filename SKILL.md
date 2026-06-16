---
name: aaa-discovery
description: Walks the operator through the Automation Architecture (AAA) Discovery Phase for a new client engagement — a 13-step sequence that produces a fully scoped, ticketed, and client-informed project before any engineer writes code. Trigger this skill whenever a new client project is starting, when the operator says "kick off discovery", "start a new client", "new client engagement", "spin up a new project", "let's begin discovery", or invokes `/aaa-discovery`. Also trigger when a sales call transcript has just been read and the next step is to start scoping the work, or when the operator references "the 13 steps", "the AAA discovery flow", or "the canonical sequence". This skill orchestrates other skills (grill-me, to-prd, aaa-client-init) and agents (cto-technical-architect, board-nanny) — invoke it as the entry point so the steps run in the right order, with the right artifacts, in the right places.
---

# AAA Discovery Phase

## What this skill does

Discovery is the AAA workflow that turns a sales conversation into a fully ticketed, client-informed project ready for engineers to build against. It is **13 sequential steps**, run end-to-end, before any code is written. The skill:

- Tracks progress through the 13 steps using the operator's task list
- Hands off to other skills (`/grill-me`, `/to-prd`, `/aaa-client-init`) and agents (`cto-technical-architect`, `board-nanny`) at the right moments
- Enforces output-location conventions (markdown in repo, DOCX in `Client Docs/`, no financial info in tech docs)
- Catches the order-dependent gotchas that bit the first project that ran this flow (project-key changes, version bumps, draft refreshes)

The phase ends with the work fully scoped, all tickets created, the client dashboard live, all spec DOCX deliverables generated into `Client Docs/`, and a discovery digest posted to `#po`. **Build Phase** (engineers writing code) only begins after step 13.

## Throughput target

**48 hours from signed SOW to step-13 complete.** This is the number every run is measured against. The main external dependency is step 8 (engineer-led architecture grill ≤ 16 hours from `#po` notification → engineer fills last `Decision.` line). If that holds, the rest fits comfortably. Slip past 72 hours end-to-end → mandatory post-mortem in `docs/throughput-log.md`. Full target rationale, slip signals, and tracking method live in `docs/why.md`.

## When to invoke

Use this skill as the entry point any time a new client engagement starts — whether the operator says it explicitly (`/aaa-discovery`, "kick off discovery") or implicitly (just dropped a sales call transcript and asked what's next). Don't try to do Discovery freehand — the canonical sequence catches things ad-hoc work misses.

## What you need from the operator at kickoff

Gather these before starting Step 1. Many will be visible in the sales call transcript, but ask if not.

- **Client business name** (full, used in `Client Docs/<name>/` paths) — e.g., "Kidneyhood"
- **Client primary contact** (name + email) — e.g., "Lee Hull, l.hull@kidneyhood.org"
- **Project name** — what we'll call this engagement — e.g., "Zendesk AI Agent"
- **Slug** — kebab-case, used for repo + dashboard + Jira workflow — e.g., "kidneyhood-zendesk-agent"
- **Client initials directory** — short identifier for the local working dir — e.g., "kh" → `~/Documents/aaa/client_projects/kh/`
- **Project sprint channel: `#<slug>-sprint`** (e.g. `#broa-opps-builder-sprint`) — referenced in the step-8 engineer notification. If it doesn't exist yet at kickoff, that's fine — it's typically created during discovery when the project is renamed `*-discovery` → `*-build` → `*-sprint`. Confirm it exists before reaching step 8.
- **Assigned engineer** — name + Slack user ID. Often not known at kickoff; gets assigned by Minh Anh / PM mid-discovery. Must be known by step 8 — that's when they pick up the architecture grill.
- **Sales call transcript pointer** — Fireflies URL, Granola meeting ID, or path under `docs/client-comms/`

If anything is unclear, ask before starting. Don't infer slugs or short names — they end up baked into URLs, Jira keys, and dashboard routes.

## The 15 steps

Each step has a dedicated reference file under `references/step-NN-<name>.md` with the full playbook. SKILL.md gives the overview and delegation points; the reference files have the commands, the file paths, the gotchas, and the verification checks.

| # | Step | Reference | Output |
|---|------|-----------|--------|
| 1 | Read sales call meeting transcripts | `references/step-01-read-transcripts.md` | Internal context, no artifact |
| 2 | Read the signed proposal (formal scope + deliverables) | `references/step-02-read-proposal.md` | Internal context, no artifact |
| 3 | Write the project brief | `references/step-03-write-brief.md` | `spec/project-brief.md` (v1.0) |
| 4 | `/grill-me` on the project brief | `references/step-04-grill-me-brief.md` | Locked-in product decisions |
| 5 | Write the PRD via `/to-prd` | `references/step-05-write-prd.md` | `spec/prd.md` (v1.0) |
| 6 | Create Jira space + empty board | `references/step-06-create-jira.md` | Jira project + board |
| 7 | Create GitHub repo with README | `references/step-07-create-github.md` | `Automation-Architecture/<slug>` repo |
| 8 | Notify engineer via `#po` and stage architecture grill stub (**engineer-led**) | `references/step-08-grill-me-arch.md` | Slack message sent to `#po`; `spec/GRILL_SESSION.md` Round 2 stub committed |
| 9 | Write tech spec | `references/step-09-tech-spec.md` | `spec/tech-spec.md` |
| 10 | Populate Jira board with Epics + Tasks (`board-nanny`) | `references/step-10-board-nanny.md` | Tickets created |
| 11 | Create client dashboard entry (`/aaa-client-init`) | `references/step-11-client-dashboard.md` | Dashboard PR merged |
| 12 | Generate spec DOCX deliverables into `Client Docs/` | `references/step-12-spec-docx.md` | Brief, PRD, Tech Spec DOCX in `Client Docs/<Client>/` |
| 13 | Post discovery digest to `#po` | `references/step-13-discovery-digest.md` | Slack message in `#po` with all 13 steps + artifact links |

## Progress tracking

Add the 13 steps to the task list at kickoff so the operator can see where they are. Mark each step `in_progress` when you start it and `completed` as soon as it lands — don't batch.

## Output-location conventions (non-negotiable)

These match the operator's global rules. Reread them periodically; the temptation to drop files in the wrong place is real.

- **Markdown source of truth** lives in the project's repo at `~/Documents/aaa/client_projects/<initials>/repo/<project>/spec/`. Examples: `spec/project-brief.md`, `spec/prd.md`, `spec/tech-spec.md`.
- **Pre-Discovery artifacts — transcripts** (sales call recordings) live in `~/Documents/aaa/Client Docs/<Client Full Business Name>/Meeting Transcripts/`. Read them in step 1.
- **Pre-Discovery artifacts — signed proposal** lives in the **Onboarding Shared Drive** on Google Drive (Drive ID: `0AOk2FIY4h-9gUk9PVA`), under `<Client Full Business Name>/proposal/`. Read via the Google Drive MCP in step 2.
- **DOCX deliverables** are generated via pandoc directly into `~/Documents/aaa/Client Docs/<Client Full Business Name>/<area>/`. Never generate a DOCX into the repo first and then copy. If you find a DOCX in the repo, `git rm` it.
- **Memory** for the project lives at `~/.claude/projects/-Users-brad-Documents-aaa-client-projects-<initials>-repo-<project>/memory/`.
- **No financial information in any technical doc** — no budget, no pricing, no payment status, no proposal terms. That belongs in `Client Docs/<Client>/proposal/` and the sales conversation only. If you find financial info in a tech doc, remove it.
- **GitHub repos** go under the `Automation-Architecture` org, never personal accounts.

## Tools and skills used across the 13 steps

| Tool / skill / agent | Steps where used |
|----------------------|------------------|
| Fireflies MCP, Granola MCP, file reads | 1 |
| Google Drive MCP (`mcp__claude_ai_Google_Drive__search_files` + `read_file_content`) | 2 |
| Markdown drafting | 3, 5, 9, 11 |
| `/grill-me` skill | 4, 10 |
| `/to-prd` skill | 5 |
| Atlassian MCP (Jira) | 6, 12 |
| `gh` CLI (GitHub) | 7, 13 |
| Slack MCP | 8 (notify engineer via `#po`) |
| `cto-technical-architect` agent | 11 |
| `board-nanny` agent | 12 |
| `/aaa-client-init` skill | 13 |
| `pandoc` (markdown → DOCX into `Client Docs/`) | 14 |
| Markdown drafting → `client-comms/<file>.md` | 15 |

## Phase boundary

Discovery ends after step 13 (the `#po` digest is sent). **Build Phase** then takes over with three high-level steps: Phase 1 build (supervised), burn-in period, Phase 2 launch (autonomous + any remaining channels). Do not roll Build steps into this skill — they're not part of Discovery and they're project-specific.

## Common pitfalls (from the first run of this flow)

These are the things that went sideways on the Kidneyhood Zendesk Agent project. Heads-up so you don't repeat them.

1. **Project key churn.** The operator may recreate the Jira project under a new key after step 5 (e.g., `KZA` → `KHZ`). When this happens, sweep the codebase + memory + sync workflow + DOCX for stale references. The sweep is non-trivial — keep a checklist.
2. **DOCX path discipline.** All DOCX generation happens in **step 12**, not ad-hoc throughout the flow. Pandoc writes directly into `Client Docs/`, never into the repo. Old versioned DOCX files in `Client Docs/` are deleted on version bump, not left to accumulate. All DOCX deliverables are current before the step 13 digest goes out.
3. **`/grill-me` is two rounds, not one — and the second is engineer-led.** Round 1 (step 4) tests product scope and the operator drives. Round 2 (step 8) tests architecture and the **assigned engineer** drives. The operator stages a stub in `spec/GRILL_SESSION.md` (questions + recommended starting positions), commits via PR, and sends a Slack message to `#po` tagging the engineer. The engineer either runs `/grill-me` interactively from the project repo or edits the file directly via PR. Skipping round 2 — or running it without the engineer — means architecture defaults get made solo and re-litigated mid-build.
4. **Version bumps signal substantive changes.** PRD v1.0 → v1.1 should reflect meaningful scope changes discovered during step 8 or thereafter. PRD v1.1 → v1.2 should reflect post-tech-spec corrections. Don't bump for cosmetic edits.

## How to kick off

When this skill is invoked:

1. Confirm the kickoff inputs (client name, contact, project name, slug, initials, Slack channels, transcript pointer)
2. Add the 13 steps to the task list
3. Read `references/step-01-read-transcripts.md` and start step 1
4. Move sequentially. Don't run steps in parallel — the artifacts feed forward.
5. After each step, mark it complete and read the next reference file before proceeding.

If the operator wants to deviate (skip a step, run them out of order, change tooling), pause and ask before improvising. Discovery is a sequence; out-of-order work has caused rework on every project where it happened.

Begin.
