# aaa-discovery

The canonical home of the **AAA Discovery** Claude Code skill — the 15-step sequence that turns a closed sale into a fully ticketed, team-reviewed, client-informed project ready for engineers to build.

## What lives here

| Path | What it is |
|---|---|
| [`SKILL.md`](./SKILL.md) | The skill itself — read this first. Defines the 15 steps, output-location conventions, common pitfalls. |
| [`references/`](./references/) | One reference file per step (`step-01-...md` through `step-15-...md`). The skill body delegates here for full playbooks, commands, and verification checks. |
| [`templates/`](./templates/) | Bundled templates the skill uses (e.g. `project-brief.md`). |
| [`docs/why.md`](./docs/why.md) | The throughput framing, target (≤ 48 hours), slip signals, and how throughput is measured. |
| [`docs/throughput-log.md`](./docs/throughput-log.md) | Append-only ledger of every Discovery run's wall-clock — ground truth for whether the workflow is moving the bottleneck. |

## How it's installed

This repo is the **canonical source of truth**. The runtime install is a hard copy at `~/.claude/skills/aaa-discovery/`. After editing the skill in this repo, sync the install (see _Sync_ below) and reload Claude Code.

The old project-scoped location at `<aaa-client-dashboard>/.claude/skills/aaa-discovery` is a symlink back to this repo for backwards compatibility.

## Team installation

To install the skill on your machine:

```bash
git clone git@github.com:Automation-Architecture/aaa-discovery.git
cd aaa-discovery
./sync.sh
```

Then restart Claude Code. The skill will be available as `/aaa-discovery` in any project directory.

To pick up future updates, pull and re-run `sync.sh`:

```bash
git pull
./sync.sh
```

## Sync

After editing files in this repo, run:

```bash
./sync.sh             # sync to ~/.claude/skills/aaa-discovery/
./sync.sh --dry-run   # preview what would change without touching files
```

Then restart Claude Code so the skill reloads.

The script wraps `rsync` with the canonical exclusions (`.git`, `README.md`, `docs/`, `sync.sh`, `.gitignore`) so you don't accidentally drop repo metadata or human-facing docs into the runtime install.

## Editing rules

- **SKILL.md is the entry point.** Every behavior change starts here, then cascades into `references/` if the relevant step needs detail.
- **Reference files are step-scoped.** `step-NN-<name>.md` names are stable — Jira links, the dashboard, and other docs reference them.
- **Versioning matters.** Bump the skill description's step count if you add or remove steps. The pitfalls list (in `SKILL.md`) is append-only — record gotchas as they happen on real projects.

## Trigger

Invoke from any project directory with `/aaa-discovery` whenever a new client engagement starts. Don't run discovery freehand — the canonical sequence catches things ad-hoc work misses.

## Worked example

The first end-to-end run of this flow was the **Kidneyhood Zendesk AI Agent** project ([`Automation-Architecture/kidneyhood-zendesk-agent`](https://github.com/Automation-Architecture/kidneyhood-zendesk-agent)). Use it as a reference for what the artifacts look like in practice — not just what the templates promise.

| Step(s) | Artifact | Where to look |
|---|---|---|
| 3, 9 | Project brief (v1.5 by close of discovery) | [`spec/project-brief.md`](https://github.com/Automation-Architecture/kidneyhood-zendesk-agent/blob/main/spec/project-brief.md) |
| 5, 9 | PRD | [`spec/prd.md`](https://github.com/Automation-Architecture/kidneyhood-zendesk-agent/blob/main/spec/prd.md) |
| 11 | Tech spec | [`spec/tech-spec.md`](https://github.com/Automation-Architecture/kidneyhood-zendesk-agent/blob/main/spec/tech-spec.md) |
| 12 | Jira board | `KHZ` project on `automationarchitecture.atlassian.net` (9 Epics + 60 Tasks at discovery close) |
| 15 | Client handoff email | [`client-comms/email-to-lee-discovery-handoff.md`](https://github.com/Automation-Architecture/kidneyhood-zendesk-agent/blob/main/client-comms/email-to-lee-discovery-handoff.md) |

A few caveats worth knowing before treating this run as canonical:

- **No `GRILL_SESSION.md`.** The KH run predates the bundled grill-session template — both rounds happened ad-hoc in chat. Future runs use `templates/GRILL_SESSION.md` to capture decisions in-repo.
- **Project key churn (`KZA` → `KHZ`).** This is pitfall #1 in `SKILL.md`. The KH run is what taught us to sweep for it.
- **DOCX path discipline learned mid-flight.** Early DOCX got generated into the repo; we cleaned them out and moved generation directly into `Client Docs/`. The final state matches the convention; the git history shows the migration.

Treat the artifact shapes as the reference, not the process — the process is what `SKILL.md` and the `references/` files describe today, refined from the KH lessons.

## Template / external distribution

A generalized, org-neutral version of this skill is available for external distribution at [`Automation-Architecture/aaa-discovery-template`](https://github.com/Automation-Architecture/aaa-discovery-template) (public). That repo replaces all AAA-specific values with placeholders and includes an `install.sh` for end users. When making substantive improvements to the skill (new steps, refined reference files, new pitfalls), port them to the template as well.
