# Step 9 — Write the tech spec

## Goal

A technical specification that closes every architecture decision and gives engineers a complete brief to build from. Tech spec is the authoritative handoff document. PRD says **what**; tech spec says **how**.

## How to invoke

First, **scaffold `spec/tech-spec.md` from the bundled template** at `templates/tech-spec.md` (in this skill). Then point the agent at the scaffolded file so it fills in the canonical structure rather than producing a divergent shape:

```
cp <skill-path>/templates/tech-spec.md <project-repo>/spec/tech-spec.md
```

Then invoke the `cto-technical-architect` agent:

```
Agent({
  description: "Write tech spec for <Project>",
  subagent_type: "cto-technical-architect",
  prompt: "Fill in spec/tech-spec.md (already scaffolded from the canonical template). The PRD is at spec/prd.md. Architecture decisions are locked in spec/GRILL_SESSION.md Round 2 — every entry in §8 'Concrete Tech Choices' must come from a Round 2 Q. Reference these files: <paths>. Architecture-locked items: <summary>."
})
```

The agent's job is to synthesize, not to redecide. If it tries to relitigate something Round 2 already settled, redirect it. If it tries to deviate from the scaffolded structure (renaming sections, dropping required ones), pull it back unless there's a real reason — consistency across projects is a feature.

## Where it lives

`~/Documents/aaa/client_projects/<initials>/repo/<project>/spec/tech-spec.md`

## Structure (typical)

The agent will follow its own template, but a complete tech spec normally includes:

```markdown
# Tech Spec: <Project>

## System Context
  - Architecture diagram
  - External dependencies

## Module Specifications
  - For each module from the PRD: detailed interface, internal design, dependencies, error handling

## Data Model
  - Full DDL, indexes, foreign keys
  - Migration strategy

## API Contracts
  - Every endpoint: method, path, request schema, response schema, errors
  - Webhook payloads

## Sequence Diagrams
  - For the main flows: end-to-end with all actors

## Concrete Tech Choices
  - Final picks (locked by step 8): runtime versions, library versions, service tiers

## Deployment
  - Infra-as-code or stepwise commands
  - Environments (dev, staging, prod)
  - Secret management

## Testing Strategy
  - Unit / integration / eval — what runs where
  - CI gates

## Observability
  - Events emitted, metrics tracked, alert thresholds

## Security
  - Auth (webhook, admin API, internal service-to-service)
  - PII / data classification

## Open Questions
  - The handful of things still TBD — should be small at this point
```

## After the agent finishes

1. Read it end-to-end. Check for:
   - **Consistency with the PRD** — module names match, data flow matches, scope matches
   - **No financial info** (global rule)
   - **No reintroduced scope** the PRD declared out
   - **Concrete versions** (e.g., "Python 3.12", "Postgres 16", "Pinecone serverless tier") — not "TBD"
2. Commit and push to the project repo
3. Generate the DOCX and upload to Drive:
   ```bash
   pandoc spec/tech-spec.md \
     -o /tmp/<slug>-Tech-Spec-v1.0.docx \
     --from markdown --to docx
   ```
   Then upload via Google Drive MCP (`mcp__claude_ai_Google_Drive__create_file`) to the Onboarding Shared Drive (`0AOk2FIY4h-9gUk9PVA`) → `<Client Full Business Name>/deliverables/`. Filename: `<Client>-<Project>-Tech-Spec-v1.0.docx`.

## Don't do this

- **Don't let the tech spec contradict the PRD.** They're co-authored documents. If the tech spec needs to deviate, update the PRD too (and consider whether you need to re-run step 8).
- **Don't put implementation details in the brief or PRD.** Specific versions, library choices, service tiers go here, not in the upstream docs.

## Verify before moving on

- `spec/tech-spec.md` exists, committed
- DOCX in `Client Docs/`
- Module names + data flow match the PRD
- No financial info

## Done when

Tech spec is written and committed. Move to step 10.
