# Step 7 — Send brief + PRD DOCX to `#next` for team feedback

## Goal

Get the internal team to read the brief and PRD before they reach the client. The team has perspective the operator and you don't (industry-specific risks, stale assumptions, similar past projects, vendor preferences). Their feedback is what step 8 incorporates.

## The channel

`#next` — Slack channel for project review. **Not** the client-facing channel (typically `#client-comms`). Don't mix them up.

## How to do it

Two paths depending on Slack MCP availability:

### Path A — Slack MCP

If the Slack MCP is connected (`mcp__claude_ai_Slack__*`), draft a message and send it to `#next` with the DOCX files as canvas links or via attachment if the MCP supports that. Otherwise, post a message and tell the operator to upload the DOCX files manually.

### Path B — operator does it manually

Tell the operator:

> Brief and PRD DOCX are ready at:
> - `/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<filename-brief>.docx`
> - `/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<filename-prd>.docx`
>
> Please post both to `#next` with a quick note: "New project — `<Project Name>`. Looking for team feedback on the brief and PRD before we proceed to architecture grill-me. Anything obvious that's missing or wrong?"
>
> Let me know once you've posted so we can move to step 8.

## Don't do this

- **Don't post to `#client-comms`.** That's a client-facing channel.
- **Don't paste the brief/PRD content into the Slack message.** They're DOCX deliverables — the team should download and review.
- **Don't proceed to step 8 before feedback comes in.** If the team is silent for too long, ping them — but don't substitute your own self-review for their feedback. The whole point of step 7 is outside eyes.

## Done when

The operator confirms the DOCX files have been posted to `#next` and (in most cases) team feedback has come back. Move to step 8.
