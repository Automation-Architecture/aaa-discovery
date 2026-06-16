# Step 9 — Discovery document evaluation (quality gate)

## Goal

Score the three discovery documents (brief, PRD, tech spec) against a six-dimension rubric before any Jira tasks are created. This is a hard gate: unresolved failures block step 10 (board-nanny Phase 2). Catching a bad spec here is cheap; catching it after 40+ Jira cards have been generated from it is expensive.

## Prerequisites

- `spec/project-brief.md` — approved and committed (step 3)
- `spec/prd.md` — approved and committed (step 5)
- `spec/tech-spec.md` — approved and committed (step 8)
- `spec/GRILL_SESSION.md` — Round 2 complete (step 7)

## How to invoke

```
Agent({
  description: "Discovery eval: score brief, PRD, and tech spec for <Project>",
  prompt: "Read spec/project-brief.md, spec/prd.md, spec/tech-spec.md, and spec/GRILL_SESSION.md in full. Evaluate all six rubric dimensions below. Output the scorecard in the exact format specified. Be strict on FAILs — they block step 10. WARNs are flagged but do not block. Do not proceed past the scorecard until the operator instructs."
})
```

## The rubric

| # | Dimension | What to check | FAIL condition | WARN condition |
|---|---|---|---|---|
| 1 | **Completeness** | All required sections present in all three docs; no stubs, blanks, or TBDs | Any required section missing or contains only placeholder text | Minor stub in a non-critical sub-section |
| 2 | **Consistency** | Brief → PRD → tech spec alignment: problem statement, scope, module names, epic names | Module in PRD missing from tech spec; scope in brief contradicts tech spec | Minor naming variation (e.g., "Meeting Ingestion" vs "Ingestion Module") |
| 3 | **Epic quality** | Every PRD epic passes the usability test per `aaa-SOP/discovery-sop.md §2` | Any epic is a technical layer ("API Layer", "Database Schema") or invisible to the user | Epic is borderline — technically user-facing but very thin |
| 4 | **Measurability** | PRD objectives are concrete and testable; tech spec has real version numbers | Any objective is aspirational ("improve efficiency") with no testable condition; any version is "TBD" or "3.x" | Objective is testable but the measurement method is implicit |
| 5 | **Technical concreteness** | All Round 2 grill decisions reflected in tech spec; API contracts defined; data model present; no open architecture decisions | Any grill decision not reflected; "decide later" or "TBD" in the architecture section; data model absent | Minor gap in a non-critical contract (e.g., error response shape undefined) |
| 6 | **Financial cleanliness** | No financial information in any of the three docs | Any occurrence of `$`, "budget", "pricing", "invoice", "deposit", "payment", "cost" in a financial context | — |
| 7 | **Compliance** | For any project with PHI, PII, HIPAA, PCI, or other regulatory constraints identified in steps 1–2: vendor BAA list present in tech spec Security section; data residency confirmed; PHI/PII flow documented. Skip this dimension if no compliance constraints were identified. | Any required BAA vendor not listed; PHI enters the system without documented residency; "HIPAA TBD" or equivalent in the tech spec | Compliance scope identified but one minor vendor BAA is undocumented; data residency confirmed verbally but not written into the tech spec |

## Output format

The agent must produce the scorecard in this exact format:

```markdown
# Discovery Eval — <Project Name> (<slug>)

| Dimension | Status | Findings |
|---|---|---|
| Completeness | ✅ PASS | — |
| Consistency | ⚠️ WARN | <short finding> |
| Epic quality | ✅ PASS | — |
| Measurability | ❌ FAIL | <short finding> |
| Technical concreteness | ✅ PASS | — |
| Financial cleanliness | ✅ PASS | — |
| Compliance | ✅ PASS | — |

## Required fixes before step 10

### <Dimension> — <short title>
**Location:** <file> §<section>
**Finding:** <what is wrong>
**Fix:** <exactly what to change>

## Warnings (operator must acknowledge each before proceeding)

### <Dimension> — <short title>
**Location:** <file> §<section>
**Finding:** <what is flagged>
**Fix or confirm:** <what to do or explicitly accept>

## Overall verdict: READY FOR STEP 10 | NEEDS REVISION
```

If there are no FAILs and no WARNs, the "Required fixes" and "Warnings" sections are omitted and the verdict is `READY FOR STEP 10`.

## After the scorecard

### If any FAILs

Go back to the relevant step:

| Fail dimension | Go back to |
|---|---|
| Completeness — brief | Step 3 (revise `spec/project-brief.md`, regenerate DOCX) |
| Completeness / Epic quality / Measurability — PRD | Step 5 (revise `spec/prd.md` or re-run `/to-prd`, regenerate DOCX) |
| Consistency / Technical concreteness / Measurability — tech spec | Step 8 (revise `spec/tech-spec.md`, regenerate DOCX) |
| Financial cleanliness | Whichever file contains it — fix, regenerate DOCX |
| Compliance | Step 3 if compliance scope was not captured in the brief (add Compliance section); step 8 if captured but not in tech spec Security section — add vendor BAA list, PHI/PII flow, and data residency to `spec/tech-spec.md`, regenerate DOCX |

After fixing, re-run the eval from scratch. The eval agent reads the current files — no partial re-runs.

### If only WARNs

Read each WARN. Either:
- **Fix it** (recommended) — go back to the relevant step, update the file, regenerate DOCX, return to step 9
- **Accept it** — record the acceptance in project memory: `"Eval WARN accepted: [dimension] — [finding] — [reason] — [date]"`. Then proceed to step 10.

### If all PASS

Move directly to step 10.

## Override (operator decision)

If the operator explicitly decides to override a FAIL (e.g., a known acceptable gap with a deliberate reason), they must:

1. Record the override in project memory: `"Eval FAIL override: [dimension] — [finding] — [reason] — accepted by operator [date]"`
2. Proceed to step 10

Overrides are rare. A FAIL is almost always cheaper to fix than to carry through the build.

## Don't do this

- **Don't run this step before the tech spec is approved.** The technical concreteness and consistency dimensions require all three documents. Running the eval on a draft tech spec produces false FAILs.
- **Don't skip to step 10 on a FAIL without an explicit override.** The gate exists because board population locks in the scope — fixing epics after tasks are written is 5–10× more expensive.
- **Don't re-run the eval on individual files.** The agent reads all three docs together; consistency checks require the full picture.
- **Don't fix the markdown and forget to regenerate the DOCX.** Each document's DOCX must stay in sync with its markdown source.

## Done when

Scorecard shows all PASS (or all WARNs acknowledged), and the verdict is `READY FOR STEP 10`. Move to step 10.
