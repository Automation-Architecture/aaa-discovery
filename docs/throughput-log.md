# Throughput Log

Running record of every Discovery run's wall-clock — signed SOW → step 15 complete. Append-only. One line per project.

**Target:** ≤ 5 business days. Slip past 7 → post-mortem (note root cause in the line).

**Format:**

```
<YYYY-MM-DD>  <slug>  <N business days>  <notes — what helped / what slipped>
```

`<YYYY-MM-DD>` is the step-15 completion date (when the client handoff email was staged). `<slug>` matches the repo / dashboard slug. `<N>` is business days from project-brief "Date drafted" → step-15 file creation.

---

## Runs

<!-- Append below this line. Most recent at the bottom. -->
