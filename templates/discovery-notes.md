# Discovery Notes — _<Project Name>_

> **Stage:** Step 3 of the discovery workflow. The output of the **grilling round**. Each Unknown from the brief gets resolved here, branch by branch, until shared understanding is reached.

---

## How to use this file

- One **Decision** entry per resolved branch — question, the answer, the reason, the source.
- Open items go under **Open questions** until resolved (then promote to Decisions).
- **Assumptions** captures things the operator *believes* but cannot yet prove — the engineer needs to know which of these are load-bearing.
- **Risks** surface anything that could derail the build or the engagement.

---

## Decisions

### D-01 — _<short title>_

- **Question:** _<the unknown that was grilled>_
- **Decision:** _<resolution>_
- **Rationale:** _<why this answer, what was rejected, what tradeoffs)>_
- **Source:** _<grilling round / specific transcript / operator>_

### D-02 — _<short title>_

- **Question:** _<...>_
- **Decision:** _<...>_
- **Rationale:** _<...>_
- **Source:** _<...>_

---

## Open questions

_Branches that didn't resolve in this round. Either grill further, defer, or escalate to the client._

- _<question>_ — Owner: _<who will resolve>_ — Target: _<date or milestone>_

---

## Assumptions

_The brief assumed X. The grilling confirmed/changed it to Y. List the ones the engineer must know are assumptions, not facts._

- _<assumption>_ — confidence: _<low / med / high>_ — impact if wrong: _<...>_

---

## Risks

_What could break this build, the timeline, or the engagement?_

- _<risk>_ — likelihood: _<...>_ — mitigation: _<...>_

---

## Next step

Feed this file plus `project-brief.md` into `to-prd` (or the equivalent PRD-creation skill) to produce `prd.md`.
