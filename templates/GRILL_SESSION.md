# _<Project Name>_ — PRD Grill Session

> **Project:** _<Project codename>_
> **Client:** _<Full business name>_
> **Repo:** _<github URL>_
> **Slug:** _<kebab-case-slug>_

## How to read this document

This file captures every architecture- and product-layer **decision** that came out of the two `/grill-me` rounds during Discovery. Each question has three parts:

- **The question** — the open branch the round resolved
- **Recommended starting position** (or "Recommended answer" in Round 1) — what was proposed before the round started, with brief rationale
- **`Decision.`** — the final answer

Three valid forms for each `Decision.` line:

1. `**Decision.** Accept.` — the recommendation stands as-is
2. `**Decision.** Refine. <tweak + reasoning>` — close but adjust X
3. `**Decision.** Reject. <alternative + reasoning>` — doesn't fit, here's what instead, and why

Don't leave a `Decision.` line as `_TBD_` once the round is in progress. If you genuinely can't pick (need a spike, blocked on client input), record that as the decision: `**Decision.** Spike required — <ticket #>`.

Once both rounds are locked (no more `_TBD_`), the tech spec (step 11) is mostly transcription, not invention.

---

## Q1 — _<short question title>_

_<the open question, 2-3 sentences. Round 1 = product/scope. Limit Round 2 to architecture/implementation.>_

**Recommended answer.** _<the operator's proposed answer + brief rationale. Reference the proposal or transcript if relevant.>_

**Decision.** _TBD_

## Q2 — _<short question title>_

_<...>_

**Recommended answer.** _<...>_

**Decision.** _TBD_

<!--
  Repeat for each Round 1 question — typically 10–15. Keep them product-shaped:
  scope, audience, success criteria, integrations from the user's POV, edge cases,
  pilot gates, accuracy thresholds, etc. Architecture questions go in Round 2.
-->

## Cumulative impact

_<2-4 sentences: how the locked decisions reshape the project. Scope additions, deferred features, anything that contradicts the brief or proposal. Flag anything that warrants a v1.1 bump on the brief or PRD.>_

## Cross-links to Jira

- _<JIRA-KEY-1>_ — _<brief description, status>_
- _<JIRA-KEY-2>_ — _<...>_

---

# Round 2 — Architecture & Tech Stack (Engineer-Led)

> **Owner:** _<assigned engineer name + Slack ID>_
> **Date staged:** _<YYYY-MM-DD>_
> **Goal:** Lock implementation-layer architecture decisions. Driven by the **assigned engineer** (the grill-ee). The operator stages the questions and the recommended starting positions; the engineer makes the picks.

## How to use this section

> **Engineer**: each Q below has a starting position to react to. Skip anything the PRD already locks (don't re-litigate the LLM choice if `prd.md` already says `claude-sonnet-4-6`). Add new questions if you find a gap.
>
> When all `Decision.` lines are filled, the round is done — `cto-technical-architect` agent picks up to author `spec/tech-spec.md`.

## Q1 — _<implementation-layer question>_

_<the open question, 2-3 sentences. Stay in the architecture/tech-stack lane — anything product-shaped belongs back in Round 1 above.>_

**Recommended starting position.** _<the operator's proposal + brief rationale. Reference the PRD if it implies a constraint.>_

**Decision.** _TBD_

## Q2 — _<implementation-layer question>_

_<...>_

**Recommended starting position.** _<...>_

**Decision.** _TBD_

<!--
  Repeat for each Round 2 question — typically 10–15. The full menu of common
  architecture questions (backend language, LLM choice, embeddings, vector DB,
  relational DB, deploy target, eval platform, observability, queue, webhook auth,
  compliance, channels & SLAs, cost controls, prompt management, failure modes,
  test layers, module breakdown, CI shape, secret management, local dev, DB
  migrations) is documented in references/step-10-grill-me-arch.md — pick the
  ones the PRD doesn't already lock.
-->

## Cumulative impact

_<how the architecture decisions feed the tech spec. Confirm what's locked. Flag anything that needs a PRD revision back upstream (e.g., an architecture choice that constrains the user-facing behavior beyond what the PRD assumed).>_

## Cross-links to Tech Spec

- _<tech-spec section / heading>_
- _<...>_

---

## Sign-off

- [ ] **Round 1 complete** — all Decisions filled, operator confirms
- [ ] **Round 2 complete** — all Decisions filled, engineer confirms
- [ ] **Tech spec drafted** (step 11) — `spec/tech-spec.md` exists

When all three are checked, Discovery moves to step 12 (board population via `board-nanny`).
