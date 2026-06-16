# Step 4 — Autonomous product scope grill (two-agent)

## Goal

Stress-test product scope, behavior, edge cases, and unstated assumptions without requiring the operator to answer questions interactively. Two Claude agents work in sequence for each decision: an **Opinion Agent** generates a perspective on the question, and an **Orchestrator** synthesizes that opinion into a final recommendation and auto-accepts it. By the end, every major product decision has a confirmed answer recorded in `spec/GRILL_SESSION.md`.

## How it works

For each product-layer question:

1. **Opinion Agent** — spawned via the `Agent` tool. Given the project brief and the question, it generates a reasoned opinion: what it would recommend and why, surfacing tradeoffs and edge cases.
2. **Orchestrator** (the main Claude session) — receives the Opinion Agent's output, weighs it against the brief context, forms a final recommendation, and records it as the accepted decision. No operator confirmation is required.

Invoke the Opinion Agent for each question like this:

```python
Agent({
  description: "Opinion: <question short label>",
  prompt: """
You are advising on a product decision for <Project Name>.

Brief context: <paste relevant brief sections>

Question: <question text>

Give your opinion: what you would recommend and why. Surface the key
tradeoff and any edge cases the recommendation depends on. Be direct —
one recommendation, not a menu of options.
"""
})
```

After receiving the Opinion Agent's output, the Orchestrator records the decision immediately to `spec/GRILL_SESSION.md` in this format:

```markdown
### <Question label>
**Question:** <full question text>
**Opinion Agent:** <summary of opinion agent's reasoning>
**Decision:** <the orchestrator's final recommendation — auto-accepted>
**Rationale:** <one sentence on why this was chosen over alternatives>
```

Run all questions sequentially. Do not batch Opinion Agents in parallel — each decision may inform the framing of the next question.

## Questions to cover (product-layer only)

Do not drift into architecture (database choice, deployment platform, queue mechanism) — those are step 8.

- Autonomy posture (supervised? autonomous? hybrid? graduation criteria?)
- Confidence model (how does the system decide when to act?)
- Escalation behavior (silent or visible? to whom? with what context?)
- Clarification flow (does the system ask follow-up questions? how many rounds? what timeout?)
- Safety / sensitive content handling (does the system filter? if so, on what categories?)
- Output format (length, citation style, tone, disclaimers)
- Knowledge sources (which? which formats? indexed how?)
- Channels (which inbound surfaces? same SLA across them?)
- Edge cases (spam, abuse, off-topic, multi-question messages, identity)
- User context (cross-thread? same-thread? none?)
- Failure modes (fail silent? retry? fallback?)
- AI identity disclosure (declare or stay silent?)
- Launch criteria (what does "done" look like?)

## Saving the decisions

All decisions land in `spec/GRILL_SESSION.md` as the session runs — write each one immediately after the Orchestrator accepts it, not in a batch at the end. After the session completes, transfer the locked decisions into project memory at `~/.claude/projects/-Users-brad-...-<project>/memory/`. The PRD in step 5 will reference all of them.

## Don't do this

- **Don't ask the operator to answer questions.** This step is fully autonomous. If a question genuinely cannot be resolved without operator input (missing context not in the brief or proposal), flag it as an open item and move on — don't block the session.
- **Don't let questions drift into architecture.** Queue mechanism, vector DB choice, DB tooling — those are step 8. If a question belongs there, skip it here and add it to the Round 2 stub.
- **Don't batch Opinion Agents in parallel.** Each decision can change the framing of the next question. Run them sequentially.
- **Don't override a decision mid-session without recording why.** If the Orchestrator disagrees with the Opinion Agent, record both positions and the reason for the divergence.

## Done when

All product-layer questions are resolved and recorded in `spec/GRILL_SESSION.md`. Move to step 5.
