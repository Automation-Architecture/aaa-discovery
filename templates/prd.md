# PRD — _<Project Name>_

> **Stage:** Step 4 of the discovery workflow. The **developer-ready handoff**. Built from `project-brief.md` and `discovery-notes.md`. The engineer reading this should be able to start building without re-running discovery.

---

## Meta

- **Client:** _<Full business name>_
- **Project codename:** _<short identifier>_
- **Author:** _<operator name>_
- **Date:** _<YYYY-MM-DD>_
- **Status:** _Draft / Approved / In Build_

## 1. Overview

_Two paragraphs max. What is being built and why. The engineer should leave this section knowing the shape of the thing._

## 2. Goals & non-goals

**Goals:**
- _<bullet>_

**Non-goals:**
- _<bullet>_

## 3. Users & key journeys

_Who uses this and what they do. Walk the engineer through the primary flow before diving into requirements._

- **Persona:** _<role>_ — does _<X>_ to achieve _<Y>_
- **Primary journey:** _<step 1 → step 2 → step 3>_

## 4. Functional requirements

_Each requirement maps cleanly to a Jira card (User Story + Description + Acceptance Criteria) — see the AAA Jira ticket structure._

### FR-01 — _<short name>_

- **User story:** As a _<role>_, I want _<capability>_, so that _<outcome>_.
- **Description:** _<context, dependencies, edge cases>_
- **Acceptance criteria:**
  - [ ] _<testable check>_
  - [ ] _<testable check>_

### FR-02 — _<short name>_

- **User story:** As a _<role>_, I want _<capability>_, so that _<outcome>_.
- **Description:** _<...>_
- **Acceptance criteria:**
  - [ ] _<...>_

## 5. Non-functional requirements

_Performance, accessibility, security, observability, browser/device support, etc._

- _<requirement>_

## 6. System design

_High-level architecture. The engineer should be able to start sketching components from this section._

- **Stack:** _<frontend, backend, db, infra>_
- **External services / integrations:** _<APIs, webhooks, OAuth, etc.>_
- **Data model:** _<entities and relationships, or link to schema)>_
- **API contracts:** _<list endpoints or link to OpenAPI / inline doc>_

## 7. Success criteria

_How we'll know the build is done and the engagement delivered._

- _<measurable outcome>_

## 8. Out of scope

_What this PRD explicitly does **not** cover._

- _<bullet>_

## 9. Open questions

_Lifted from `discovery-notes.md` — anything still unresolved that the engineer needs to know about, plus owners._

- _<question>_ — Owner: _<who>_ — Blocker: _<yes/no>_

## 10. References

- Project brief: _<path>_
- Discovery notes: _<path>_
- Source transcripts: _<paths>_
- Proposal: _<path>_

---

> _Reminder: this PRD is a tech document. **No financial information** (pricing, deposits, payment status) belongs here — that lives in `Client Docs/<business name>/`._
