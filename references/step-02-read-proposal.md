# Step 2 — Read the signed proposal

## Goal

Internalize the formal scope, deliverables, and stakeholders the client has *signed off on*. The proposal is the authoritative pre-Discovery contract document. Reading it complements the sales call transcripts: transcripts capture what was discussed, the proposal captures what was committed.

## Where the proposal lives

Proposals are stored in the **Onboarding Shared Drive** on Google Drive:

- **Shared Drive:** [Onboarding](https://drive.google.com/drive/folders/0AOk2FIY4h-9gUk9PVA)
- **Drive ID:** `0AOk2FIY4h-9gUk9PVA`
- **Expected path inside the drive:** `<Client Full Business Name>/proposal/`

Use the Google Drive MCP (`mcp__claude_ai_Google_Drive__search_files`) to locate the file:

```
query: "title contains 'Proposal' and parentId = '<client-folder-id>'"
```

Or browse directly via the Drive URL above. Typical filename: `<Business Name>_Proposal_<Engineer>.pdf` (or `.docx`). There may also be a signed SOW separately.

To read the file once located, use `mcp__claude_ai_Google_Drive__read_file_content` with the file ID returned by the search.

If the proposal isn't in the Onboarding Shared Drive, **stop and ask the operator** — Discovery should not proceed without one. The proposal is what got the client to sign and is non-negotiable as a Discovery input.

> **Note:** The previous location was `~/Documents/aaa/Client Docs/<Client Full Business Name>/proposal/`. Proposals for new engagements are now stored in the Onboarding Shared Drive instead.

## What to extract

- **Defined scope** — what the proposal explicitly committed to deliver. The brief and PRD must respect this; out-of-scope items in the proposal are out-of-scope for Discovery.
- **Deliverables list** — concrete artifacts the client expects (e.g., "deployed agent + admin dashboard + 2-week burn-in support")
- **Timeline expectations** — start date, target launch, any contractual milestones
- **Stakeholders & decision-makers** — names + roles, especially anyone who signs off beyond the primary contact
- **Required client-provided assets** — books, content libraries, historical data, access credentials
- **Compliance constraints** — any regulatory, data residency, or industry constraints called out
- **Integration scope** — which third-party systems the proposal commits to integrating with

## What NOT to extract into tech docs

The proposal contains financial information (pricing, payment terms, invoicing schedule). **Do not surface any of this in the brief, PRD, tech spec, README, Jira, or any other tech artifact.** Per the operator's global rule: tech docs stay technical. Financial content stays in `Client Docs/<Client>/proposal/` and the sales conversation only.

When you read the proposal in this step, *use* the budget/timeline information to inform your understanding of constraints, but never copy it into a tech doc. The "Timeline" you write in the brief should be in calendar terms (e.g., "2–3 week build window") not in invoicing terms.

## How to read it

PDFs are the most common format. Use `mcp__claude_ai_Google_Drive__read_file_content` with the file ID to retrieve the content — load the tool schema first via `ToolSearch("select:mcp__claude_ai_Google_Drive__read_file_content")`. If you need to extract specific tables (e.g., a milestones list), the Drive MCP returns plain text that Claude can parse directly.

If you find ambiguity between the proposal and the sales call transcripts (e.g., transcript says "we'll do X" but proposal omits X, or vice versa), surface this immediately to the operator. Don't paper over it. The operator decides whether the brief tracks the proposal or the latest verbal agreement.

## What to write down

Like step 1 (sales call transcripts), don't create a new artifact yet. The brief in step 3 is the consolidation. Just make sure you can answer:
- "What did the client formally commit to receive?"
- "What did the client formally commit to provide?"
- "What's explicitly out-of-scope per the proposal?"

## Done when

You have the formal scope and deliverables crisp in your working context, alongside the transcript-derived context from step 1. Move to step 3.

## Pitfalls

- **Don't conflate signed proposal with verbal agreement.** If the operator agreed to add or remove something on a later call, the proposal is stale unless an addendum or revised SOW exists. Ask.
- **Don't copy financial figures into the brief or PRD.** Re-read the global rule if you're tempted.
- **Don't skip this step because "the operator already knows what's in it."** The skill's job is to be useful even when the operator hasn't reread the proposal in weeks.
