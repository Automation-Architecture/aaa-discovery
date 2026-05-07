# Step 3 — `/grill-me` on the project brief

## Goal

Stress-test product scope, behavior, edge cases, and unstated assumptions. The brief is a starting point; `/grill-me` walks the decision tree and locks each branch with the operator. By the end, every major product decision has a confirmed answer.

## How to invoke

Use the Skill tool with `grill-me`:

```
Skill(skill="grill-me")
```

The skill will run as an interactive interview. Don't try to script it — let `/grill-me` do its job. Your role here is to feed it the right context, not to drive the questions.

## What to ask `/grill-me` to focus on (product-layer)

Hand it the brief and ask it to focus on **product / user-experience / scope** decisions. Don't let it drift into architecture (that's step 9). Examples of product-layer questions it should be asking:

- Autonomy posture (supervised? autonomous? hybrid? graduation criteria?)
- Confidence model (how does the system decide when to act?)
- Escalation behavior (silent or visible? to whom? with what context?)
- Clarification flow (does the system ask follow-up questions? how many rounds? what timeout?)
- Safety / sensitive content handling (does the system filter? if so, on what categories?)
- Output format (length, citation style, tone, disclaimers)
- Knowledge sources (which? which formats? indexed how?)
- Channels (which inbound surfaces? same SLA across them?)
- Edge cases (spam, abuse, off-topic, multi-question messages, identity)
- Patient/user context (cross-thread? same-thread? none?)
- Failure modes (fail silent? retry? fallback?)
- AI identity disclosure (declare or stay silent?)
- Launch criteria (what does "done" look like?)

## Saving the decisions

`/grill-me` should be saving each locked decision to a plan file (`~/.claude/plans/<random-name>.md`) by default. After the session, transfer the locked decisions into your working memory for the project at `~/.claude/projects/-Users-brad-...-<project>/memory/` if they're worth keeping (most are). The PRD will reference all of them in step 4.

## Don't do this

- **Don't run `/grill-me` and then ignore its output.** The decisions it surfaces are the substrate for the PRD. Skipping them and writing a generic PRD wastes the round.
- **Don't let it drift into architecture.** Queue mechanism, vector DB choice, DB tooling — those are step 9. If `/grill-me` starts asking those, redirect it to product-layer questions.
- **Don't try to "win" against the operator's choices.** When the operator picks a non-recommended option, document the choice and the reasoning. They know things you don't (client preferences, business constraints, prior context).

## Done when

The `/grill-me` session has resolved every major product decision branch. Operator has explicitly approved (typically by saying "done" or "ok let's move on"). Move to step 4.
