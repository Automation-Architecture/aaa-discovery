# AI Roofing Cost Estimator — Grill Session

> **Project:** roofdata-sprint | **Client:** Tom / RoofingProjects.com

---

# Round 1 — Product & Scope (Autonomous, 2026-06-29)

## Q1 — Autonomy posture
**Decision.** Accept. Always return an answer; surface confidence annotations as non-blocking badges. No human-in-the-loop review gate.

## Q2 — Confidence model
**Decision.** Accept. Three confidence tiers: HIGH (≥15 projects, no widening), MODERATE (5–14 or any widening applied), LOW (<5 after full widening). Labour/material split disclosed as persistent footnote on all cards — structurally separate from confidence tier.

## Q3 — Clarification flow
**Decision.** Accept. Answer-first is non-negotiable. Default assumptions: job type → full replacement; membrane type ambiguity → one acceptable inline clarification question. Angular results card must render active-parameter chips.

## Q4 — Output format and length
**Decision.** Refine. Four-element structure: (1) headline range, (2) three-cell data row, (3) 3–4 sentence explanation, (4) footnote. Suppress entirely only if widened query returns zero projects.

## Q5 — Role-differentiated output
**Decision.** Refine. Roofer receives spec card (membrane/job type distribution + match count), never a stripped cost card. `SpecSummaryCardComponent` must be standalone — never shares data bindings with `CostResultsCardComponent`.

## Q6 — Multi-turn context scope
**Decision.** Refine. Full-merge model, no result retention, 10-turn cap. 3+ simultaneous new parameters = silent session reset.

## Q7 — Project summary generator scope
**Decision.** Accept. Button on project record detail view only. User-initiated. Role filtering at Node.js before prompt assembly. Ships July 25 only if detail view screen already exists.

## Q8 — Off-topic and abuse handling
**Decision.** Accept. Two-layer defence: Node.js intent classifier (zero roofing params → reject, zero Claude spend) + Claude `OUT_OF_SCOPE` sentinel intercepted by Node.js before reaching Angular.

## Q9 — AI identity disclosure
**Decision.** Accept. AI attribution in Angular results card only — persistent, non-dismissible label. Not in Claude response text.

## Q10 — Failure mode behaviour
**Decision.** Accept. Named errors, never silent failure. Data graph API `AuthError` → immediate Vauyani alert. Claude API error → one retry after 30 seconds.

## Q11 — Data freshness and bid_year filter
**Decision.** Accept. `bid_year >= '2024'` is a hard system constraint, never configurable by users, never widened as a fallback.

## Q12 — Launch criteria and demo scope
**Decision.** Accept. Live production data for demo. "Demo-ready": correct estimate within 5 seconds for three Tom-approved scenarios; LOW CONFIDENCE path demonstrates gracefully. Vauyani + Tom walkthrough July 24.

---

## Cumulative Impact (Round 1)

Three-tier confidence model replaces brief's single LOW CONFIDENCE trigger. Answer-first flow requires active-parameter chips on Angular results card. Roofer spec card requires separate Node.js endpoint + standalone component. Two-layer off-topic defence adds Node.js classifier module. Open items: dual-role account policy, confirm project record detail view exists.

---

# Round 2 — Architecture & Tech Stack (Engineer-Led)

> **Owner:** Brad | **Status:** Stub staged — Brad fills in on first SSH access (Phase 2 start)

## A1 — Query intent parsing
**Recommended:** Heuristic/regex classifier. **Decision.** _TBD_

## A2 — Categories collection caching
**Recommended:** In-process Node.js Map, 1-hour TTL. **Decision.** _TBD_

## A3 — Session context store (PM2 single vs. multi-process)
**Recommended:** Confirm `pm2 list` on first SSH. Single-instance → plain Map; multi-instance → sticky sessions. **Decision.** _TBD_

## A4 — Data graph API HTTP client
**Recommended:** Use existing library in `package.json`. **Decision.** _TBD_

## A5 — Labour/material ratio storage
**Recommended:** Named constants in module source. **Decision.** _TBD_

## A6 — Claude system prompt management
**Recommended:** File loaded at startup (`prompts/estimator-system-prompt.txt`). **Decision.** _TBD_

## A7 — OUT_OF_SCOPE sentinel interception
**Recommended:** `if (response.trim() === 'OUT_OF_SCOPE')` string equality check. **Decision.** _TBD_

## A8 — Failure logging
**Recommended:** Extend existing logging approach — check codebase. **Decision.** _TBD_

## A9 — Claude API retry
**Recommended:** `await sleep(30000)` in async handler. **Decision.** _TBD_

## A10 — Angular component integration
**Recommended:** New `AiEstimatorModule` with own routing (or follow existing standalone conventions). **Decision.** _TBD_

## A11 — Test strategy
**Recommended:** Unit tests for Ratio Processor + RBAC Middleware only. Everything else manual Phase 5. **Decision.** _TBD_

## A12 — Project record detail view prerequisite
**Recommended:** Brad confirms on first SSH. If absent, Epic 5 deferred. **Decision.** _TBD_

---

## Sign-off
- [x] Round 1 complete — all 12 decisions locked
- [ ] Round 2 complete — Brad confirms A1–A12
- [ ] Tech spec signed off
