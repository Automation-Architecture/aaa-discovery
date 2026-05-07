# aaa-discovery

The canonical home of the **AAA Discovery** Claude Code skill — the 15-step sequence that turns a closed sale into a fully ticketed, team-reviewed, client-informed project ready for engineers to build.

## What lives here

| Path | What it is |
|---|---|
| [`SKILL.md`](./SKILL.md) | The skill itself — read this first. Defines the 15 steps, output-location conventions, common pitfalls. |
| [`references/`](./references/) | One reference file per step (`step-01-...md` through `step-15-...md`). The skill body delegates here for full playbooks, commands, and verification checks. |
| [`templates/`](./templates/) | Bundled templates the skill uses (e.g. `project-brief.md`). |
| [`docs/why.md`](./docs/why.md) | The throughput framing — why this skill exists and what success looks like. |

## How it's installed

This repo is the **canonical source of truth**. The runtime install is a hard copy at `~/.claude/skills/aaa-discovery/`. After editing the skill in this repo, sync the install (see _Sync_ below) and reload Claude Code.

The old project-scoped location at `<aaa-client-dashboard>/.claude/skills/aaa-discovery` is a symlink back to this repo for backwards compatibility.

## Sync

After editing files in this repo:

```bash
# from the repo root
rsync -a --delete \
  --exclude='.git' --exclude='README.md' --exclude='docs' \
  ./ ~/.claude/skills/aaa-discovery/
```

Then restart Claude Code so the skill reloads.

## Editing rules

- **SKILL.md is the entry point.** Every behavior change starts here, then cascades into `references/` if the relevant step needs detail.
- **Reference files are step-scoped.** `step-NN-<name>.md` names are stable — Jira links, the dashboard, and other docs reference them.
- **Versioning matters.** Bump the skill description's step count if you add or remove steps. The pitfalls list (in `SKILL.md`) is append-only — record gotchas as they happen on real projects.

## Trigger

Invoke from any project directory with `/aaa-discovery` whenever a new client engagement starts. Don't run discovery freehand — the canonical sequence catches things ad-hoc work misses.
