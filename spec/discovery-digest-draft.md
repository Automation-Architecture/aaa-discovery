# Discovery Digest — AI Roofing Cost Estimator (roofdata-sprint)

> **Destination:** `#po` (Slack channel C0B9AE6JQUR)
> **Sender:** Elsa / Automation Architecture AI
> **Status:** DRAFT — send via Slack MCP once Steps 12 (DOCXs uploaded to Drive) and Step 6 (Jira project created) are confirmed.

---

**Discovery complete: AI Roofing Cost Estimator (roofdata-sprint)**

✅ 1 — Read transcripts
✅ 2 — Read proposal (project charter — Roof.report_project_charter.pdf)
✅ 3 — Project brief (`spec/project-brief.md` v1.0)
✅ 4 — Product grill session (12 decisions locked — `spec/GRILL_SESSION.md` Round 1)
✅ 5 — PRD (`spec/prd.md` v1.0 — 5 epics)
⚠️ 6 — Jira board: pending Vauyani creating the project (suggested key: RDS) — epics ready to populate from `spec/jira-tasks-draft.md`
✅ 7 — Architecture grill stub committed (`spec/GRILL_SESSION.md` Round 2, A1–A12 — awaiting Brad's sign-off in Phase 2)
✅ 8 — Tech spec (`spec/tech-spec.md` v1.0 — 8 modules, 3 API contracts)
✅ 9 — Discovery eval passed (2 WARNs accepted — `spec/discovery-eval.md`)
✅ 10 — Board populated (5 epics, 34 tasks drafted — `spec/jira-tasks-draft.md`)
⚠️ 11 — Client dashboard: `spec/project.config.yaml` ready — run `/aaa-client-init` locally to register
⚠️ 12 — DOCX deliverables: generate and upload locally:
  - `pandoc spec/project-brief.md -o /tmp/RoofingProjectsCom-AI-Roofing-Cost-Estimator-Brief-v1.0.docx --from markdown --to docx`
  - `pandoc spec/prd.md -o /tmp/RoofingProjectsCom-AI-Roofing-Cost-Estimator-PRD-v1.0.docx --from markdown --to docx`
  - `pandoc spec/tech-spec.md -o /tmp/RoofingProjectsCom-AI-Roofing-Cost-Estimator-Tech-Spec-v1.0.docx --from markdown --to docx`
  - Upload all three to Onboarding Shared Drive → `RoofingProjects.com/deliverables/`
✅ 13 — This digest

---

**Key artifacts:**
- Repo: https://github.com/Automation-Architecture/roofdata (client project)
- Discovery branch: `claude/onboard-roofdata-sprint-x53338` (in `aaa-discovery` repo)
- Jira: https://automationarchitecture.atlassian.net/jira/software/projects/RDS/boards (create first)
- Dashboard: https://dashboard.automationarchitecture.ai/client/roofdata-sprint (after `/aaa-client-init`)
- DOCX deliverables: Onboarding Shared Drive → `RoofingProjects.com/deliverables/`

---

**Assigned engineer:** Brad (Slack user ID needed — confirm with Vauyani)
**Next:** Build Phase — Brad picks up the sprint board and begins Phase 1 environment setup (SSH, IP whitelisting, .env)

---

**Key decisions (Round 1):**
- Confidence model: three-tier badge (HIGH ≥15, MODERATE 5–14, LOW <5 after geo widening) — never suppressible
- Answer-first — at most one inline follow-up; active-parameter chips on results card
- Roofer gets separate spec card endpoint (`/api/ai/spec`) — standalone `SpecSummaryCardComponent`
- Epic 5 conditional: ships July 25 only if project record detail view already exists
- Labour/material split Phase 1: industry ratios, labelled in every footnote

**Open items:**
1. Tom's contact email
2. Server IP whitelisting with Shivam (Phase 1 Day 1 blocker)
3. Brad's SSH public key → Vauyani adds to `authorized_keys`
4. Shivam's data graph API documentation
5. API credentials (`ROOFDATA_API_KEY`, `ROOFDATA_SECRET_KEY`) delivered securely to Brad
6. Jira project creation (Vauyani) + board URL
7. Does project record detail view exist? (Brad confirms on first SSH)
8. PM2 single or multi-process? (Brad confirms on first SSH)
9. Brad's Slack user ID

**Hard deadline: July 25, 2026 — Simon Property Group demo, Indianapolis.**
