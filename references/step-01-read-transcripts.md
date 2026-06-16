# Step 1 — Find and read the sales call transcript

## Goal

Build internal context before drafting the brief. The sales call (and any follow-up calls) is where the client's vision, pain, constraints, budget hint, and timeline expectations were verbalized. Reading the transcript carefully is the cheapest way to avoid asking the client questions they already answered.

## How to find the transcript

You need two inputs: the **business name** and the **name of the attendee** (typically the primary client contact). Use these to search Fireflies first, then fall back to Granola.

### Fireflies (primary)

Use `mcp__claude_ai_Fireflies__fireflies_search` with a keyword query combining the business name and attendee name:

```
keyword:"<Business Name>" scope:all limit:10
```

Or search by participant email if known:
```
participants:<attendee-email> limit:10
```

Scan the results for the discovery/sales call — look for the meeting title, date, and attendees list to confirm it's the right one. Then use `mcp__claude_ai_Fireflies__fireflies_get_transcript` with the meeting ID to pull the full transcript.

### Granola (fallback)

Use `mcp__claude_ai_Granola__query_granola_meetings` with a natural-language query:

```
"<Business Name> discovery call with <Attendee Name>"
```

### Local files (last resort — exported recordings only)

Files at `~/Documents/aaa/client_projects/<initials>/docs/client-comms/` named like `YYYY-MM-DD-<topic>-fireflies.md`. Only valid if exported from a recording — a notes file typed after the call does not count as a transcript.

If no transcript is found via any of the above, **stop and ask the operator** — Discovery must not proceed on memory of a call.

### Email threads

Sometimes there's a discovery-phase email exchange. Check Gmail for `from:<client-email>` if relevant context is missing from the transcript.

## What to extract

- The **problem the client is trying to solve**, in their own words
- **Existing systems** they're using (Zendesk, Salesforce, etc.) — these become integrations
- **Stakeholders** mentioned (who decides, who approves, who reviews)
- **Constraints** — budget hints, timeline expectations, compliance posture, data residency, language preferences
- **Existing assets** — books, prior projects, content libraries, historical data
- **Risks the client is aware of** — copyright, regulatory, internal political
- **What "done" looks like to them**

## What to write down

Take notes in your working context. Don't create a new artifact yet — the brief (step 2) is the consolidation. Just be sure you can answer "what did the client actually say?" when drafting it.

## Done when

You can describe the client's problem, the rough scope they have in mind, and the constraints in two paragraphs without going back to the transcript. Move to **step 2 (read the signed proposal)** — the transcript captures discussion, the proposal captures commitments. You'll consolidate both into the brief in step 3.
