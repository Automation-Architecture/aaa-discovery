# Why this skill exists

## The bottleneck

Discovery is the bottleneck. New clients are onboarding faster than discovery can hand them off, and engineering sits idle waiting for clarity. Every day a project lingers in discovery is a day the build phase doesn't start.

This skill exists to **unblock engineering** — to graduate post-sales artifacts (transcripts, proposals, emails) into a developer-ready PRD + tech spec predictably and quickly, so build can commence without delay.

## The goal

**Closed-sale to build-ready in days, not weeks** — without dropping below the quality floor (engineer's mental model = operator's mental model).

If the engineer needs a re-discovery round, **throughput failed**. If the build starts but builds the wrong thing, **the floor failed**. Both are failure modes.

## The target

**5 business days from signed SOW to step-15 complete (build-ready).** This is the number we measure against on every run. Beat it where we can; flag and post-mortem when we miss it.

### Sub-targets — the two slack points

Most of the 15 steps are operator-driven and fast. Two have external dependencies that drive the wall-clock:

- **Step 8 → 9 (team feedback in `#next`):** ≤ 1 business day. If `#next` hasn't responded within 1 business day of the post, nudge in-thread.
- **Step 10 (engineer-led architecture grill):** ≤ 2 business days from operator stages questions → engineer fills the last `Decision.` line. If the engineer hasn't picked it up within 1 business day of the Slack handoff, escalate to PM.

If both sub-targets hold, the remaining steps comfortably fit inside 2 business days.

### Slip signals (when to escalate)

- **Day 3 with no PRD locked** (steps 1–5 incomplete) → operator-side bottleneck. Block off time and finish; don't drift.
- **Day 5 with `GRILL_SESSION.md` Round 2 still has open `_TBD_` lines** → engineer-side bottleneck. Escalate to PM.
- **End-to-end > 7 business days** → mandatory post-mortem. Log root cause in `docs/throughput-log.md` so the pattern doesn't repeat across projects.

### How throughput is measured

Each project's wall-clock = days between **`spec/project-brief.md` "Date drafted"** (step 3) and **`client-comms/email-to-<client>-discovery-handoff.md` creation date** (step 15). After step 15, append a single line to `docs/throughput-log.md` in this canonical repo:

```
<YYYY-MM-DD>  <slug>  <N business days>  <notes — what helped / what slipped>
```

The log is the agency's ground truth on whether the workflow is actually moving the bottleneck. If targets stop holding across multiple runs, that's a signal to revise the skill, not raise the targets.

## Why throughput is the design constraint, not quality

Quality is the floor we don't drop below — enforced not by document length but by **the engineer co-authoring the architecture decisions** in step 10's engineer-led grill round. Sequential operator-only discovery generates decisions the engineer silently re-litigates mid-build. Dual-track participation kills that loop.

The design constraint is **fewer round-trips, less re-discovery, faster handoff** — because that's where the agency loses time at scale.

## Why a 15-step skill instead of a free-form process

Free-form discovery looks fast in the moment but produces rework downstream. The 15 sequential steps catch the order-dependent gotchas that bit the first project that ran this flow (project-key changes, version bumps, draft refreshes, DOCX path discipline, the team feedback round before client send-off).

Throughput at the agency scale isn't about speeding up any single step — it's about removing the rework loops that compound across projects.
