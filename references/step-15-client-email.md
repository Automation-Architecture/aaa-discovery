# Step 15 — Write client email markdown with dashboard link and all spec docs

## Goal

A polished email body — written as markdown to disk, in the project repo — that the operator copies into Gmail (or any other sender) and sends to the client. Three DOCX files are attached manually. Discovery ends with this artifact in place.

**The skill does NOT create or maintain a Gmail draft.** That was a v1 misstep; the markdown-in-repo pattern is simpler, more durable, and doesn't drift when specs change.

## Where it lives

`~/Documents/aaa/client_projects/<initials>/repo/<project>/client-comms/email-to-<client>-discovery-handoff.md`

Create the `client-comms/` directory if it doesn't exist. This file is committed to the repo — it's part of the project's record, not a private artifact.

## What goes in the markdown file

The file has three sections:

### 1. Header (yaml-style at the top)

```markdown
# Client Email — Discovery Handoff for <Client Project Name>

**To:** <Client primary contact name> (`<email>`)
**From:** <Operator name> (`<operator email>`)
**Subject:** <chosen subject line>
**Date drafted:** <YYYY-MM-DD>
**Purpose:** Discovery handoff. Marks the end of Discovery Phase and the start of Build pending the client's review and the few outstanding asks.
```

### 2. Subject line options

Two or three subject line variants the operator picks from. Examples:
- `<Project> — brief, PRD, and tech spec ready for your review`
- `<Client Project Name> — three documents ready, a few things I need from you`
- `Discovery wrapped on <project>; review when you get a chance`

### 3. Email body (the actual prose)

A code block with the email content, no markdown formatting (Gmail doesn't render markdown well). Structure:

- **Opener** — short, references Discovery wrapping
- **What's attached** — the three docs, with one-line descriptions of what each is for
- **Dashboard link** — `https://dashboard.automationarchitecture.ai/client/<slug>`
- **What we locked during Discovery (post client feedback)** — bullets of decisions the client should know about
- **What I still need from you** — concrete asks, prioritized by what blocks the next sprint
- **Heads up — coming during burn-in** — set expectations on burn-in approval bandwidth
- **Next milestone** — what the first sprint looks like, rough timing
- **Sign-off**

### 4. Notes for the operator

A short section at the end of the markdown file with practical reminders:
- The body is plain text; the operator pastes into Gmail and adds their signature
- Three attachments to attach manually, with full paths to the DOCX files in `Client Docs/<Client>/prd/<slug>/`
- Note when the dashboard URL becomes live (after Vercel redeploys)
- Anything else the operator should know before sending

## Tone

- **Plain, direct, warm.** No marketing language.
- **Front-load the asks.** The client's eye scans the first 3–4 lines; put the dashboard link, the doc list, and the top "I need from you" bullet in the first half.
- **Acknowledge what they already gave you.** If their feedback round resolved compliance, copyright, etc., mention it explicitly. Reinforces that the spec reflects them, not a generic template.
- **Match the operator's existing voice with the client.** Read the existing email threads in `docs/client-comms/` from earlier in the engagement; adopt the operator's level of formality.

## Don't do this

- **Don't create a Gmail draft via `gws gmail users drafts create`.** The skill flow doesn't include a Gmail step. The operator chooses the sending tool.
- **Don't paste the full text of the brief/PRD/tech spec into the email.** Three DOCX attachments + dashboard link. Period. The email is the cover letter.
- **Don't include financial information.** Same global rule. Pricing, payment, contract terms belong in the proposal, not the email.
- **Don't promise dates the operator hasn't agreed to.** "Estimated 2–3 weeks of focused build" is fine if the brief and tech spec back it. "Build complete by Friday" is not.
- **Don't list the client's still-pending asks at the bottom.** They go in the middle, prioritized. Things that were resolved during Discovery go above them. Things that are heads-ups (not asks) go below.

## Verify before moving on

- File exists at `client-comms/email-to-<client>-discovery-handoff.md`
- All three subject line options are reasonable
- Body opens with the dashboard link visible in the first half
- Three attachments listed by full path
- "What I need from you" is a short, ordered list of concrete asks
- "What we locked during Discovery" reflects the actual feedback round (not a template)
- File committed to the repo

## Done when

The markdown file is committed to the repo, all three DOCX paths in the file resolve to existing files, and the operator has confirmed they can read it. **Discovery Phase is now complete.** Build Phase begins after the operator sends the email and any client-side responses come back (e.g., source files arriving for ingestion).

## Why this changed from v1 of the skill

v1 of `aaa-discovery` had this step create a Gmail draft via `gws`. We learned on the first project (Kidneyhood Zendesk Agent) that maintaining the draft across spec version bumps was high-toil and the operator was rewriting the body anyway. Markdown-in-repo gives the same artifact (clear email content, three attachment paths, dashboard URL) without the tooling churn.
