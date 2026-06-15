# Throughput Log

Running record of every Discovery run's wall-clock — signed SOW → step 13 complete. Append-only. One line per project.

**Target:** ≤ 48 hours. Slip past 72 hours → post-mortem (note root cause in the line).

**Format:**

```
<YYYY-MM-DD>  <slug>  <N business days>  <notes — what helped / what slipped>
```

`<YYYY-MM-DD>` is the step-13 completion date (when the `#po` discovery digest was sent). `<slug>` matches the repo / dashboard slug. `<N>` is business days from project-brief "Date drafted" → step-13 `#po` message sent.

---

## Runs

<!-- Append below this line. Most recent at the bottom. -->
