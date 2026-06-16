# Step 7 — Architecture grill (engineer-led) and Jira epic updates

## Goal

Lock the architecture decisions for the build and update the Jira epics to reflect any scope changes from the grill findings. By the end of this step: `spec/GRILL_SESSION.md` Round 2 is filled in by the engineer, committed to `main`, and the Jira epics reflect the finalized scope.

## How this step is structured

| Phase | Who | What |
|---|---|---|
| A — Stage the stub | PO | Read PRD + Round 1, write Round 2 stub → PR to GitHub, notify engineer |
| B — Fill the stub | Engineer (async) | Review Jira epics, fill in Round 2 decisions → PR to GitHub |
| C — Update Jira | PO (returns after Phase B) | Read completed grill, update Jira epics via MCP → PR to GitHub |

---

## Phase A — PO stages the grill stub

### 1. Read the inputs

Read `spec/prd.md` and `spec/GRILL_SESSION.md` (Round 1) end-to-end. Many architecture decisions are already implied by the PRD — only the truly open ones go in Round 2. Confirm:

- Jira epics from step 6 are live on the board and assigned to the engineer
- The engineer's Slack user ID is in project memory (captured at step 6)

### 2. Write the Round 2 stub

Append to `spec/GRILL_SESSION.md` a new section titled **"Round 2 — Architecture & Tech Stack (Engineer-Led)"**.

A good stub:

- Lists 10–15 **open** implementation-layer questions (see menu below)
- Skips anything the PRD already locks (don't re-ask "what LLM" if the PRD names one)
- For each question: recommended starting position + brief rationale — gives the engineer something to react to, not a blank page
- Marks each decision `**Decision.** _TBD_`
- Names the engineer as decision-maker

**Architecture question menu** (pick only the open ones):

- Backend language — Python, Node, or Go?
- LLM choice — Opus/Sonnet/Haiku? OpenAI? Per-call tier or single-tier?
- Embeddings model — OpenAI, Voyage, Cohere, self-hosted?
- Vector DB — pgvector, Pinecone, Weaviate, ChromaDB?
- Relational DB — Supabase, Neon, Railway Postgres, RDS?
- Deploy target — Vercel, Railway, Render, Fly.io?
- Eval platform — Braintrust, LangSmith, homegrown?
- Observability — PostHog, Datadog, Sentry, structured logs?
- Queue mechanism — Redis, Postgres LISTEN/NOTIFY, in-memory, none?
- Webhook auth — HMAC, IP allowlist, both?
- Compliance posture — HIPAA/BAA needed? Data residency? Log retention?
- Channels + SLAs — async vs sync; latency budgets?
- Cost controls — caps, alerts, none?
- Prompt management — code-only, DB-stored, hybrid?
- Failure modes — fail silent, retry, fallback?
- Test layers — unit, integration, eval? Which modules need unit tests?
- CI shape — GitHub Actions? Which gates?
- Secret management — env vars, Doppler, Vault?
- Local dev setup — docker-compose, devcontainer, native?
- DB migration tooling — Alembic, Prisma, hand-rolled?

### 3. Commit and PR

```bash
git checkout -b discovery/step-07-grill-stub
git add spec/GRILL_SESSION.md
AAA_COMMIT_OK=1 git commit -m "docs(spec): add Round 2 architecture grill stub"
git push -u origin discovery/step-07-grill-stub
gh pr create \
  --title "Step 7: Architecture grill Round 2 stub" \
  --body "Round 2 grill stub appended to spec/GRILL_SESSION.md. Engineer to fill in and PR back."
aaa-merge <#>
```

### 4. Notify engineer via `#po`

Once the PR merges, send directly to `#po` (channel ID `C0B9AE6JQUR`) via `mcp__claude_ai_Slack__slack_send_message`. No draft.

The message should:

- Tag the engineer (`<@engineer-userid>`)
- Name the project and slug
- Link directly to `spec/GRILL_SESSION.md` on `main` in the GitHub repo
- Remind them their Jira epics are assigned and waiting for review (link to the board)
- List the open questions as a short numbered preview
- Ask them to: review Jira epics, fill in `spec/GRILL_SESSION.md` Round 2 decisions, create a PR, and tag in `#po` when done
- Mention `#<slug>-sprint` for live discussion on high-stakes decisions

After sending, move on. Do not block the skill here — Phase B is async.

---

## Phase B — Engineer fills the stub (async)

This phase is **engineer-driven and asynchronous**. The engineer was notified in step 6 to pull the repo; this notification tells them the grill stub is committed and ready.

**The engineer should:**

1. Pull the latest `main` from the GitHub repo
2. Open the Jira board and review each assigned epic
3. Open `spec/GRILL_SESSION.md` → "Round 2 — Architecture & Tech Stack"
4. Fill in each decision, replacing `_TBD_` with a concrete choice + rationale
5. Create a PR from their branch
6. Tag the PO in `#po` when done

The PO moves on and does not wait. Step 8 (tech spec) confirms Round 2 is complete before running the tech spec agent — it will not proceed until every decision is resolved.

---

## Phase C — PO updates Jira epics based on grill findings

Once the engineer tags done and their PR is ready:

### 1. Merge the engineer's PR

```bash
aaa-merge <engineer-PR#>
```

### 2. Read the completed grill

Read `spec/GRILL_SESSION.md` Round 2 end-to-end. Flag any decision that:

- Changes the scope of a Jira epic (module split, feature de-scoped)
- Introduces a new dependency between epics
- Adds a constraint that wasn't in the PRD (compliance, latency SLA, data residency)

### 3. Update Jira epics via Atlassian MCP

For each affected epic, update its description to reflect the settled architecture decisions:

Load the tool schema first: `ToolSearch("select:mcp__atlassian__editJiraIssue")`

```
mcp__atlassian__editJiraIssue({
  issueIdOrKey: "<KEY>-<N>",
  fields: {
    description: "<updated description incorporating grill decisions>"
  }
})
```

Only update descriptions here. Do not add or remove epics — that requires an operator decision. If the grill revealed a scope gap that needs a new epic, flag it for the operator before touching Jira.

### 4. Commit spec updates → PR to GitHub

If any spec files were updated based on grill findings:

```bash
git checkout -b discovery/step-07-post-grill-updates
git add spec/
AAA_COMMIT_OK=1 git commit -m "docs(spec): update epics and spec from Round 2 grill findings"
git push -u origin discovery/step-07-post-grill-updates
gh pr create \
  --title "Step 7: Post-grill Jira + spec updates" \
  --body "Jira epics and spec updated based on engineer architecture decisions."
aaa-merge <#>
```

---

## Don't do this

- **Don't skip the engineer.** Operator-only architecture decisions are re-litigated mid-build.
- **Don't stage the stub before epics exist in Jira.** Epics are the engineer's input — they must be live on the board before the engineer fills in the grill.
- **Don't update Jira before reading the full grill.** One decision often affects multiple epics; read the whole Round 2 first.
- **Don't add new epics in Phase C without operator sign-off.** Jira scope changes are operator decisions.
- **Don't send either `#po` message as a draft.** Both messages (step 6 and step 7) go directly.
- **Don't block the skill after Phase A.** Step 8 gates on a complete grill — check it there, not here.

---

## Done when

Round 2 stub committed to `main` → engineer's completed grill committed to `main` → Jira epics updated → any spec PRs merged. Move to step 8.
