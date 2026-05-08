# Step 10 — `/grill-me` on architecture & implementation choices

## Goal

The second `/grill-me` round. Round 1 (step 3) locked the product. This round locks the build. By the end, every architecture-layer decision has a confirmed answer so the tech spec (step 11) is mostly transcription, not invention.

## Who runs this round

**The engineer assigned to the project drives this round, not the operator.** The operator's job is to schedule the grill, frame business constraints (pilot timeline, client trust posture, cost ceilings), and unblock anything that requires sales/client context. The engineer's job is to make the architecture picks — they're the one who will live with the decisions during build.

This is a deliberate change from Round 1 (where the operator was the grill-ee for product scope). Architecture defaults made without the engineer in the room get re-litigated mid-build, slowing velocity and eroding ownership. Bring the engineer in here.

If the engineer hasn't been assigned yet at this step, **stop and assign them first**. Don't run the architecture grill without the person who'll do the work.

## Canonical workflow (operator-side)

This is the default flow. The operator stages the round; the engineer runs it.

### 1. Confirm the engineer is assigned

Find the assigned engineer for this project. Sources, in order:

- The project's Jira board (assignee on `<KEY>-1` Discovery & Setup epic, or asked in `#client-comms`)
- The project's Slack sprint channel — look for the most recent `Minh Anh / PM` "I'll assign this project to <@engineer>" message
- The aaa-client-dashboard's project record

If no engineer is assigned, **stop**. Notify the operator (and Minh Anh if applicable). Don't run the architecture grill without them — operator-only architecture grills produce decisions engineers silently re-litigate mid-build.

### 2. Identify the project's engineering Slack channel

Convention: `#<slug>-sprint` (e.g. `#broa-opps-builder-sprint`). Confirm via Slack search:

```
mcp__claude_ai_Slack__slack_search_channels(query="<slug>")
```

Pick the `*-sprint` channel (not `*-discovery`, `*-blocked`, or the client-facing `#client-comms`). If it doesn't exist, the discovery hasn't reached the build-phase channel rename — flag to the operator.

### 3. Stage the architecture grill stub

Read `spec/PRD.md` and `spec/GRILL_SESSION.md` (Round 1) end-to-end first. Many architecture decisions are *already implied* by the PRD — only the truly open ones go in Round 2. A good Round 2 stub:

- Lists 10–15 **open** implementation-layer questions (see "What to ask" below for the menu)
- Skips anything the PRD already locks (don't re-ask "what LLM" if the PRD says Sonnet)
- For each question, includes a **Recommended starting position** with brief rationale — gives the engineer something to react to instead of a blank page
- Marks each `**Decision.** _TBD_`
- Names the engineer as owner

Append it to `spec/GRILL_SESSION.md` as a new section titled **"Round 2 — Architecture & Tech Stack (Engineer-Led)"**. If `spec/GRILL_SESSION.md` doesn't exist yet, scaffold it from `templates/GRILL_SESSION.md` (bundled in this skill) and fill in Round 1 first. See the BROA Opportunity Builder GRILL_SESSION.md for a reference shape of a fully-completed session.

### 4. Commit and PR-merge

```
git checkout -b grill-round-2-architecture
git add spec/GRILL_SESSION.md
git commit -m "docs(spec): add Round 2 architecture grill stub"
git push -u origin grill-round-2-architecture
gh pr create --title "..." --body "..."
gh pr merge <#> --admin --squash --delete-branch
git checkout main && git fetch && git reset --hard origin/main
```

(Per the global protected-`main` workflow.)

### 5. Draft the Slack handoff (skip if operator is the engineer)

If the assigned engineer is the operator themselves (solo or partial-engineering operator), skip this step entirely — no Slack handoff to yourself. Update the GRILL_SESSION.md "Owner" line to name them, commit, and they run the grill directly per the alternative mode below.

For all other cases:

Use `slack_send_message_draft` (not `slack_send_message`) — the operator should review before sending. Target the `*-sprint` channel found in step 2. The draft should:

- Tag the assigned engineer (`<@USERID>`)
- Frame the round: PRD locks conceptual stack; this is the implementation layer
- Link to the GRILL_SESSION.md section anchor on `main`
- List the open questions as a numbered preview (so they can scan without opening the doc)
- Offer two paths to run it (interactive `/aaa-discovery` step 10 in the project repo, OR direct PR edits)
- State the hard constraint: every decision concrete enough that an implementer doesn't have to guess
- Invite live discussion on the highest-stakes questions before deciding

Then notify the operator the draft is staged.

### 6. Wait for engineer to record decisions

The engineer either runs `/grill-me` interactively from the project repo or edits `spec/GRILL_SESSION.md` directly via PR. When all `Decision.` lines are filled in (no remaining `_TBD_`), the round is done.

If the engineer pushes back on a recommendation, that's the round working as intended. Capture their alternative + reasoning in the same `Decision.` line.

## Why the engineer drives this round

A deliberate change from Round 1 (where the operator was the grill-ee for product scope). The engineer owns the build, lives with the decisions, and is the only person who can pressure-test implementation feasibility. Operator-only architecture grills produce decisions the engineer re-litigates mid-build — slow velocity, eroded ownership, silent re-architecture.

The operator's job here is to (a) frame business constraints (pilot timeline, client trust posture, cost ceilings), (b) provide the recommended starting positions so the engineer reacts rather than starts blank, and (c) unblock anything requiring sales/client context.

## Alternative: engineer-runs-it-interactively

If the engineer prefers to drive the grill themselves rather than reacting to a stub, they can clone the project repo, open Claude Code, and run:

```
Skill(skill="grill-me")
```

with a prompt summarizing the open architecture questions and pointing at `spec/PRD.md` + Round 1 of `spec/GRILL_SESSION.md`. The skill walks them through one question at a time. Outputs land in the same place — `spec/GRILL_SESSION.md` under a "Round 2 — Architecture" section.

Best for engineers who want to think through it with the spec in front of them. The stub-first flow is the default because it's faster and gives the engineer a starting point.

## What to ask `/grill-me` to focus on (architecture-layer)

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

Decisions land in `spec/GRILL_SESSION.md` under a "Round 2 — Architecture" section. Same format as Round 1: question / recommended starting position / `Decision.` line. Commit to the repo so the tech-spec agent can read them.

Transfer significant architecture decisions to project memory.

## Don't do this

- **Don't skip this round.** It's the most-undervalued step in the canonical sequence. Skipping it means engineers make architecture defaults solo and the cost of a wrong default compounds during build.
- **Don't run it without the engineer.** Operator-only architecture grills produce decisions the engineer will silently re-litigate mid-build. If the engineer isn't assigned yet, assign them before this step.
- **Don't let it drift back to product.** If the operator is making product changes during this round, that's a signal step 3 wasn't thorough enough — capture them, but don't let them dominate the architecture session.

## Done when

Architecture-layer decision tree is fully resolved, with the engineer's sign-off on each decision. Move to step 11.
