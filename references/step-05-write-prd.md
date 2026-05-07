# Step 4 — Write the PRD via `/to-prd`

## Goal

A long-form Product Requirements Document that takes every locked decision from step 3 and turns them into:
- A formal problem statement and solution overview
- An extensive list of user stories (typically 30+)
- Implementation decisions (modules, APIs, data model, sequencing)
- Testing decisions
- Out-of-scope statements
- Open items still pending client input

## How to invoke

Use the Skill tool with `to-prd`:

```
Skill(skill="to-prd")
```

The skill is designed to consume the current session's context — it doesn't need to be re-fed the brief or the `/grill-me` decisions. It will read what's in the conversation and synthesize.

## Where it lives

`~/Documents/aaa/client_projects/<initials>/repo/<project>/spec/prd.md` (v1.0)

## Structure (the `/to-prd` skill enforces)

```markdown
# PRD: <Client Project Name>

**Version:** 1.0
**Date:** <YYYY-MM-DD>
**Status:** Draft
**Source:** Distilled from `/grill-me` session
**Companion docs:** `spec/project-brief.md`

## Problem Statement
## Solution
## User Stories (numbered, by actor — typically 30+ across all actor groups)
## Implementation Decisions
  ### Module breakdown (deep, independently testable)
  ### Key technical decisions
  ### API contracts (high-level)
  ### Data model (relational)
  ### Sequencing / phased build (informs Jira population)
## Testing Decisions
  ### What makes a good test
  ### Modules with required unit tests
  ### Modules covered by integration / eval
  ### Test layers (CI gates)
## Out of Scope
## Further Notes
  ### Open items requiring client input
  ### Risks tracked from project brief
  ### Decisions deferred to tech spec
  ### v2+ candidates (not committed)
```

## After `/to-prd` finishes

1. Skim the output for:
   - Financial info → remove (global rule)
   - "patient" / "client" / "user" terminology consistent with the brief
   - Citations to the right module names from the brief's module breakdown
   - Open items match the actual remaining unknowns
2. Commit `spec/prd.md` to git locally (the repo is created in step 6 if it doesn't exist yet — for now just save the file)
3. Generate the DOCX if you'll be sending it for team feedback in step 7:
   ```bash
   pandoc spec/prd.md -o "/Users/brad/Documents/aaa/Client Docs/<Client Full Name>/prd/<project-slug>/<Client>-<Project>-PRD-v1.0.docx" --from markdown --to docx
   ```
   Note: the `Client Docs` folder may not have a `prd/<project-slug>/` subfolder yet — `mkdir -p` it first. Path discipline: DOCX never lives in the repo.

## Don't do this

- **Don't paste financial info into the PRD.** Same global rule as the brief.
- **Don't have the PRD contradict the brief.** If the brief says "scope is X" and the PRD says "scope is Y", that's a sign you skipped the version-bump in step 8 or didn't carry over a decision. Reconcile.
- **Don't re-litigate decisions in the PRD.** If `/grill-me` decided something, the PRD records the decision and moves on. The PRD is not a discussion document.

## Done when

PRD is written, committed to local git (or saved to disk if repo doesn't exist yet), DOCX is generated to `Client Docs/`, no financial info, no contradictions with the brief. Move to step 5.
