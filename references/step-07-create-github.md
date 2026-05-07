# Step 6 — Create GitHub repo with README (and resources)

## Goal

A GitHub repo under the `Automation-Architecture` org that holds the spec markdown, README, any reference resources (third-party API docs the engineers will want offline), and eventually the source code. After this step the repo URL is shareable internally.

## Naming

The repo name should match the project slug captured at kickoff (e.g., `kidneyhood-zendesk-agent`). Don't include the org name in the repo name itself — that's redundant.

## Commands

Working in `~/Documents/aaa/client_projects/<initials>/repo/<project>/`:

```bash
# Initialize the local repo if not already
git init -b main

# Create README.md (sample below)
# Create .gitignore (sample below)

# Stage and commit
git add README.md .gitignore spec/
git commit -m "Initial scaffold: project brief, README, .gitignore"

# Create remote and push
gh repo create Automation-Architecture/<slug> \
  --private \
  --description "<One-line description from the brief>" \
  --source=. \
  --push
```

## README.md template

```markdown
# <Project Name>

<One-paragraph description from the brief — what the system does, who uses it.>

## Overview

- **<Bullet 1 — top-level capability>**
- **<Bullet 2 — top-level capability>**
- ...

## Docs

- [`spec/project-brief.md`](spec/project-brief.md) — project scope, goals, success metrics
- [`spec/prd.md`](spec/prd.md) — product requirements (user stories, modules, testing)
- [`spec/tech-spec.md`](spec/tech-spec.md) — technical specification (added in step 10)

## Status

Pre-development — Discovery Phase in progress.
```

## .gitignore template

```
# Dependencies
node_modules/
.venv/
__pycache__/
*.pyc

# Environment
.env
.env.local
.env.*.local

# Build output
dist/
build/
.next/

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp

# Logs
*.log
logs/
```

Adjust per the tech stack hinted at in the brief (e.g., add `vector-store/`, `embeddings/` if the project does RAG locally).

## Resources subfolder

If the project integrates with a third-party API (Zendesk, Salesforce, GHL, etc.), create `resources/` and prefetch the developer documentation there. This saves engineers context-switching to the vendor's docs site during build.

The `Explore` agent is good for this:

```
Agent({
  description: "Fetch and save <Vendor> developer docs",
  subagent_type: "Explore",  // or general-purpose if you need write access
  prompt: "Fetch documentation for the following <Vendor> APIs we'll be integrating with: ..."
})
```

Save each API area as a separate `resources/<vendor>-<area>.md` with a comment at the top noting the source URL and fetch date.

## Don't do this

- **Don't create the repo under your personal account.** Always `Automation-Architecture/`.
- **Don't make it public.** All client projects are private.
- **Don't put DOCX files in the repo.** That's a global rule. DOCX deliverables live in `Client Docs/`.
- **Don't include `.env` or any credentials.** The `.gitignore` is there for a reason.

## Verify before moving on

- Repo exists at `https://github.com/Automation-Architecture/<slug>`
- README.md and .gitignore present
- `spec/project-brief.md` and `spec/prd.md` committed
- Optional: `resources/` populated with vendor API docs
- Local repo tracking origin/main

## Done when

Repo is created, pushed, and the URL is shareable. Move to step 7.
