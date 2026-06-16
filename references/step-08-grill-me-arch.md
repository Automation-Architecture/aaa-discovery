# Step 8 — Stage architecture grill stub and notify engineer via `#po`

## Goal

Set up the second `/grill-me` round and hand it off to the engineer asynchronously. By the end of this step, `spec/GRILL_SESSION.md` has a populated Round 2 stub committed to the repo, and the assigned engineer has been notified via `#po` to pull the repo and fill in their decisions. The skill does not block here — the tech spec (step 9) waits for GRILL_SESSION.md Round 2 to be complete before running.

## Who runs this round

**The engineer assigned to the project drives this round, not the operator.** The operator's job is to stage the questions and frame business constraints (pilot timeline, client trust posture, cost ceilings). The engineer's job is to make the architecture picks — they're the one who will live with the decisions during build.

If the engineer hasn't been assigned yet at this step, **stop and assign them first**. Don't send the `#po` notification without a name.

## Canonical workflow (operator-side)

### 1. Confirm the engineer is assigned

Find the assigned engineer for this project. Sources, in order:

- The project's Jira board (assignee on `<KEY>-1` Discovery & Setup epic)
- The project's Slack sprint channel — look for the most recent `Minh Anh / PM` "I'll assign this project to <@engineer>" message
- The aaa-client-dashboard's project record

If no engineer is assigned, **stop**. Notify the operator (and Minh Anh if applicable). Don't send the `#po` message without a named engineer.

### 2. Stage the architecture grill stub

Read `spec/prd.md` and `spec/GRILL_SESSION.md` (Round 1) end-to-end first. Many architecture decisions are already implied by the PRD — only the truly open ones go in Round 2. A good Round 2 stub:

- Lists 10–15 **open** implementation-layer questions (see "What to include" below for the menu)
- Skips anything the PRD already locks (don't re-ask "what LLM" if the PRD says Sonnet)
- For each question, includes a **Recommended starting position** with brief rationale — gives the engineer something to react to instead of a blank page
- Marks each `**Decision.** _TBD_`
- Names the engineer as owner

Append it to `spec/GRILL_SESSION.md` as a new section titled **"Round 2 — Architecture & Tech Stack (Engineer-Led)"**. If `spec/GRILL_SESSION.md` doesn't exist yet, scaffold it from `templates/GRILL_SESSION.md` (bundled in this skill) and fill in Round 1 first. See the BROA Opportunity Builder GRILL_SESSION.md for a reference shape of a fully-completed session.

### 3. Commit and PR-merge

```bash
git checkout -b grill-round-2-architecture
git add spec/GRILL_SESSION.md
git commit -m "docs(spec): add Round 2 architecture grill stub"
git push -u origin grill-round-2-architecture
gh pr create --title "..." --body "..."
aaa-merge <#>
```

(Per the global protected-`main` workflow.)

### 4. Send the `#po` notification

Use `mcp__claude_ai_Slack__slack_send_message` — send directly, no draft, no operator review needed. Target: `#po` (channel ID `C0B9AE6JQUR`).

The message should:

- Tag the assigned engineer (`<@USERID>`)
- Name the project and slug
- State the ask: pull the repo, fill in the Round 2 decisions in `spec/GRILL_SESSION.md`, tag back when done
- Link to the GRILL_SESSION.md file on `main` in the GitHub repo
- List the open questions as a short numbered preview so they can scan without opening the file
- Mention the sprint channel (`#<slug>-sprint`) for any live discussion on high-stakes questions

Example shape:

```
Hey <@engineer> — architecture grill stub is ready for <Project Name> (<slug>). Can you pull the repo and fill in the Round 2 decisions in spec/GRILL_SESSION.md?

Repo: https://github.com/Automation-Architecture/<slug>
File: spec/GRILL_SESSION.md → "Round 2 — Architecture & Tech Stack"

Open questions:
1. Backend language — Python, Node, or Go?
2. LLM tier — Opus/Sonnet/Haiku or OpenAI?
...

Each has a recommended starting position — react to them and record your decision. Tag me here when the last TBD is filled in. Live discussion on high-stakes questions → #<slug>-sprint.
```

### 5. Move on

After the message sends, proceed to step 9 (tech spec). Do not block the skill here waiting for the engineer's response. Step 9 requires GRILL_SESSION.md Round 2 to be complete — confirm that before running the tech spec agent.

## What to include in the grill stub (architecture-layer)

- **Backend language** — Python, Node, or Go? Driven by ecosystem maturity for the project's domain.
- **LLM choice** — Opus/Sonnet/Haiku? OpenAI? Per-call tier or single-tier?
- **Embeddings model** — OpenAI, Voyage, Cohere, self-hosted?
- **Vector DB** — pgvector, Pinecone, Weaviate, ChromaDB?
- **Relational DB** — Supabase, Neon, Railway Postgres, RDS?
- **Deploy target** — Vercel, Railway, Render, Fly.io?
- **Eval platform** — Braintrust, LangSmith, homegrown harness?
- **Observability** — PostHog (LLM analytics), Datadog, Sentry, structured logs?
- **Queue mechanism** — Redis, Postgres LISTEN/NOTIFY, in-memory, none?
- **Webhook auth** — HMAC, IP allowlist, both?
- **Compliance posture** — HIPAA/BAA needed? Data residency? Logging retention?
- **Channels & SLAs** — async vs sync; latency budgets per channel
- **Cost controls** — caps, alerts, none?
- **Prompt management** — code-only, DB-stored, hybrid?
- **Failure modes** — fail silent, retry, fallback?
- **Test layers** — unit, integration, eval? Which modules need unit tests?
- **Module breakdown** — confirm or refine the deep modules from the PRD
- **CI shape** — GitHub Actions? Which gates?
- **Secret management** — env vars, Doppler, Vault?
- **Local dev setup** — docker-compose, devcontainer, native?
- **DB migration tooling** — Alembic, Prisma, hand-rolled?

## Saving the decisions

Decisions land in `spec/GRILL_SESSION.md` under the "Round 2 — Architecture" section (committed by the engineer). Transfer significant architecture decisions to project memory once the engineer signals done.

## Don't do this

- **Don't skip this round.** It's the most-undervalued step in the canonical sequence. Skipping it means engineers make architecture defaults solo and the cost of a wrong default compounds during build.
- **Don't run it without the engineer.** Operator-only architecture grills produce decisions the engineer will silently re-litigate mid-build. If the engineer isn't assigned yet, assign them before this step.
- **Don't use `slack_send_message_draft`.** This step sends directly. The operator doesn't need to review the `#po` message before it goes out.
- **Don't block the skill on the engineer's response.** Step 9 (tech spec) needs GRILL_SESSION.md Round 2 complete — but that check happens at step 9, not here.

## Done when

`spec/GRILL_SESSION.md` Round 2 stub is committed to `main` and the `#po` message is sent. Move to step 9.
