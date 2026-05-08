---
name: aaa-discovery
description: Walks the operator through the Automation Architecture (AAA) Discovery Phase for a new client engagement — a 15-step sequence that produces a fully scoped, ticketed, and client-informed project before any engineer writes code. Trigger this skill whenever a new client project is starting, when the operator says "kick off discovery", "start a new client", "new client engagement", "spin up a new project", "let's begin discovery", or invokes `/aaa-discovery`. Also trigger when a sales call transcript has just been read and the next step is to start scoping the work, or when the operator references "the 15 steps", "the AAA discovery flow", or "the canonical sequence". This skill orchestrates other skills (grill-me, to-prd, aaa-client-init) and agents (cto-technical-architect, board-nanny) — invoke it as the entry point so the steps run in the right order, with the right artifacts, in the right places.
---

# AAA Discovery Phase

## What this skill does

Discovery is the AAA workflow that turns a sales conversation into a fully ticketed, team-reviewed, client-informed project ready for engineers to build against. It is **15 sequential steps**, run end-to-end, before any code is written. The skill:

- Tracks progress through the 15 steps using the operator's task list
- Hands off to other skills (`/grill-me`, `/to-prd`, `/aaa-client-init`) and agents (`cto-technical-architect`, `board-nanny`) at the right moments
- Enforces output-location conventions (markdown in repo, DOCX in `Client Docs/`, no financial info in tech docs)
- Catches the order-dependent gotchas that bit the first project that ran this flow (project-key changes, version bumps, draft refreshes)

The phase ends with the work fully scoped, all tickets created, the client dashboard live, all spec DOCX deliverables generated into `Client Docs/`, and a client email markdown staged for the operator to send. **Build Phase** (engineers writing code) only begins after step 15.

## Throughput target

**5 business days from signed SOW to step-15 complete.** This is the number every run is measured against. The two slack points are step 8 (team feedback ≤ 1 business day) and step 10 (engineer-led architecture grill ≤ 2 business days). If both hold, the rest fits easily. Slip past 7 business days end-to-end → mandatory post-mortem in `docs/throughput-log.md`. Full target rationale, slip signals, and tracking method live in `docs/why.md`.

## When to invoke

Use this skill as the entry point any time a new client engagement starts — whether the operator says it explicitly (`/aaa-discovery`, "kick off discovery") or implicitly (just dropped a sales call transcript and asked what's next). Don't try to do Discovery freehand — the canonical sequence catches things ad-hoc work misses.

## What you need from the operator at kickoff

Gather these before starting Step 1. Many will be visible in the sales call transcript, but ask if not.

- **Client business name** (full, used in `Client Docs/<name>/` paths) — e.g., "Kidneyhood"
- **Client primary contact** (name + email) — e.g., "Lee Hull, l.hull@kidneyhood.org"
- **Project name** — what we'll call this engagement — e.g., "Zendesk AI Agent"
- **Slug** — kebab-case, used for repo + dashboard + Jira workflow — e.g., "kidneyhood-zendesk-agent"
- **Client initials directory** — short identifier for the local working dir — e.g., "kh" → `~/Documents/aaa/client_projects/kh/`
- **Slack channels:**
  - Client-facing: typically `#client-comms`
  - Team feedback: `#next`
  - **Project sprint channel: `#<slug>-sprint`** (e.g. `#broa-opps-builder-sprint`) — this is where the step-10 architecture-grill handoff to the engineer happens. If it doesn't exist yet at kickoff, that's fine — it's typically created during discovery when the project is renamed `*-discovery` → `*-build` → `*-sprint`. Confirm it exists before reaching step 10.
- **Assigned engineer** — name + Slack user ID. Often not known at kickoff; gets assigned by Minh Anh / PM mid-discovery. Must be known by step 10 — that's when they pick up the architecture grill.
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
| 8 | Send brief + PRD DOCX to `#next` for team feedback | `references/step-08-slack-team.md` | Slack post |
| 9 | Update specs with team feedback | `references/step-09-revise-specs.md` | Brief v1.1, PRD v1.1 |
| 10 | `/grill-me` on architecture & implementation (**engineer-led**) | `references/step-10-grill-me-arch.md` | Locked-in build decisions |
| 11 | Write tech spec | `references/step-11-tech-spec.md` | `spec/tech-spec.md` |
| 12 | Populate Jira board with Epics + Tasks (`board-nanny`) | `references/step-12-board-nanny.md` | Tickets created |
| 13 | Create client dashboard entry (`/aaa-client-init`) | `references/step-13-client-dashboard.md` | Dashboard PR merged |
| 14 | Generate spec DOCX deliverables into `Client Docs/` | `references/step-14-spec-docx.md` | Brief, PRD, Tech Spec DOCX in `Client Docs/<Client>/` |
| 15 | Write client email markdown with dashboard link + all spec DOCX | `references/step-15-client-email.md` | `client-comms/email-to-<client>-discovery-handoff.md` in the repo |

## Progress tracking

Add the 15 steps to the task list at kickoff so the operator can see where they are. Mark each step `in_progress` when you start it and `completed` as soon as it lands — don't batch.

## Output-location conventions (non-negotiable)

These match the operator's global rules. Reread them periodically; the temptation to drop files in the wrong place is real.

- **Markdown source of truth** lives in the project's repo at `~/Documents/aaa/client_projects/<initials>/repo/<project>/spec/`. Examples: `spec/project-brief.md`, `spec/prd.md`, `spec/tech-spec.md`.
- **Pre-Discovery artifacts** (sales call transcripts, signed proposal) live in `~/Documents/aaa/Client Docs/<Client Full Business Name>/` — `Meeting Transcripts/` and `proposal/` subdirectories. Read them in steps 1 and 2.
- **DOCX deliverables** are generated via pandoc directly into `~/Documents/aaa/Client Docs/<Client Full Business Name>/<area>/`. Never generate a DOCX into the repo first and then copy. If you find a DOCX in the repo, `git rm` it.
- **Memory** for the project lives at `~/.claude/projects/-Users-brad-Documents-aaa-client-projects-<initials>-repo-<project>/memory/`.
- **No financial information in any technical doc** — no budget, no pricing, no payment status, no proposal terms. That belongs in `Client Docs/<Client>/proposal/` and the sales conversation only. If you find financial info in a tech doc, remove it.
- **GitHub repos** go under the `Automation-Architecture` org, never personal accounts.
- **Slack channel for team feedback is `#next`**, separate from the client-facing `#client-comms`.

## Tools and skills used across the 15 steps

| Tool / skill / agent | Steps where used |
|----------------------|------------------|
| Fireflies MCP, Granola MCP, file reads | 1 |
| `Read` tool on PDF/DOCX in `Client Docs/<Client>/proposal/` | 2 |
| Markdown drafting | 3, 5, 9, 11 |
| `/grill-me` skill | 4, 10 |
| `/to-prd` skill | 5 |
| Atlassian MCP (Jira) | 6, 12 |
| `gh` CLI (GitHub) | 7, 13 |
| Slack MCP (or operator does it manually) | 8, 10 (engineer handoff for arch grill) |
| `cto-technical-architect` agent | 11 |
| `board-nanny` agent | 12 |
| `/aaa-client-init` skill | 13 |
| `pandoc` (markdown → DOCX into `Client Docs/`) | 14 |
| Markdown drafting → `client-comms/<file>.md` | 15 |

## Phase boundary

Discovery ends after step 15 (the operator sends the client email and any client-side responses come back). **Build Phase** then takes over with three high-level steps: Phase 1 build (supervised), burn-in period, Phase 2 launch (autonomous + any remaining channels). Do not roll Build steps into this skill — they're not part of Discovery and they're project-specific.

## Common pitfalls (from the first run of this flow)

These are the things that went sideways on the Kidneyhood Zendesk Agent project. Heads-up so you don't repeat them.

1. **Project key churn.** The operator may recreate the Jira project under a new key after step 5 (e.g., `KZA` → `KHZ`). When this happens, sweep the codebase + memory + sync workflow + DOCX + email draft for stale references. The sweep is non-trivial — keep a checklist.
2. **DOCX path discipline.** All DOCX generation happens in **step 14**, not ad-hoc throughout the flow. Pandoc writes directly into `Client Docs/`, never into the repo. Old versioned DOCX files in `Client Docs/` are deleted on version bump, not left to accumulate. By the time you reach step 15, all DOCX deliverables are current.
3. **Email lives in the repo, not Gmail.** Step 15 produces a markdown file under `client-comms/` in the project repo — subject options, body draft, attachment paths, and operator notes. The operator copies the body into Gmail (or any sender) and attaches the DOCX files manually. Don't create or maintain a Gmail draft as part of the skill flow. (We learned this on the first run: maintaining a Gmail draft across spec versions added churn without value, since the operator was rewriting the body anyway.)
4. **Step 8 vs sending to client.** The canonical sequence puts team feedback (`#next`, step 8) **before** sending to the client. The client email is staged in step 15 but only sent after Discovery is complete.
5. **`/grill-me` is two rounds, not one — and the second is engineer-led.** Round 1 (step 4) tests product scope and the operator drives. Round 2 (step 10) tests architecture and the **assigned engineer** drives. The operator stages a stub in `spec/GRILL_SESSION.md` (questions + recommended starting positions), commits via PR, and drafts a Slack handoff to the project's `*-sprint` channel for the engineer. The engineer either runs `/grill-me` interactively from the project repo or edits the file directly via PR. Skipping round 2 — or running it without the engineer — means architecture defaults get made solo and re-litigated mid-build.
6. **Version bumps signal substantive feedback.** Brief v1.0 → v1.1 should reflect team feedback (step 8). PRD v1.1 → v1.2 should reflect post-tech-spec corrections, etc. Don't bump for cosmetic edits.

## How to kick off

When this skill is invoked:

1. Confirm the kickoff inputs (client name, contact, project name, slug, initials, Slack channels, transcript pointer)
2. Add the 15 steps to the task list
3. Read `references/step-01-read-transcripts.md` and start step 1
4. Move sequentially. Don't run steps in parallel — the artifacts feed forward.
5. After each step, mark it complete and read the next reference file before proceeding.

If the operator wants to deviate (skip a step, run them out of order, change tooling), pause and ask before improvising. Discovery is a sequence; out-of-order work has caused rework on every project where it happened.

Begin.
