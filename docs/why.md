# Why this skill exists

## The bottleneck

Discovery is the bottleneck. New clients are onboarding faster than discovery can hand them off, and engineering sits idle waiting for clarity. Every day a project lingers in discovery is a day the build phase doesn't start.

This skill exists to **unblock engineering** — to graduate post-sales artifacts (transcripts, proposals, emails) into a developer-ready PRD + tech spec predictably and quickly, so build can commence without delay.

## The goal

**Closed-sale to build-ready in days, not weeks** — without dropping below the quality floor (engineer's mental model = operator's mental model).

If the engineer needs a re-discovery round, **throughput failed**. If the build starts but builds the wrong thing, **the floor failed**. Both are failure modes.

## The target

**48 hours from signed SOW to step-13 complete (build-ready).** This is the number we measure against on every run. Beat it where we can; flag and post-mortem when we miss it.

### Sub-target — the main external dependency

Most of the 13 steps are operator-driven and fast. One has an external dependency that drives the wall-clock:

- **Step 8 (engineer-led architecture grill):** ≤ 16 hours from `#po` notification → engineer fills the last `Decision.` line. If the engineer hasn't picked it up within 8 hours of the message, escalate to PM.

If that sub-target holds, the remaining steps comfortably fit inside 24 hours.

### Slip signals (when to escalate)

- **Hour 16 with no PRD locked** (steps 1–5 incomplete) → operator-side bottleneck. Block off time and finish; don't drift.
- **Hour 24 with `GRILL_SESSION.md` Round 2 still has open `_TBD_` lines** → engineer-side bottleneck. Escalate to PM.
- **End-to-end > 72 hours** → mandatory post-mortem. Log root cause in `docs/throughput-log.md` so the pattern doesn't repeat across projects.

### How throughput is measured

Each project's wall-clock = days between **`spec/project-brief.md` "Date drafted"** (step 3) and **the step 13 `#po` digest being sent**. After step 13, append a single line to `docs/throughput-log.md` in this canonical repo:

```
<YYYY-MM-DD>  <slug>  <N business days>  <notes — what helped / what slipped>
```

The log is the agency's ground truth on whether the workflow is actually moving the bottleneck. If targets stop holding across multiple runs, that's a signal to revise the skill, not raise the targets.

## Why throughput is the design constraint, not quality

Quality is the floor we don't drop below — enforced not by document length but by **the engineer co-authoring the architecture decisions** in step 8's engineer-led grill round. Sequential operator-only discovery generates decisions the engineer silently re-litigates mid-build. Dual-track participation kills that loop.

The design constraint is **fewer round-trips, less re-discovery, faster handoff** — because that's where the agency loses time at scale.

## Why a 15-step skill instead of a free-form process

Free-form discovery looks fast in the moment but produces rework downstream. The 13 sequential steps catch the order-dependent gotchas that bit the first project that ran this flow (project-key changes, version bumps, draft refreshes, DOCX path discipline).

Throughput at the agency scale isn't about speeding up any single step — it's about removing the rework loops that compound across projects.
