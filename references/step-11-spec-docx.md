# Step 11 — Verify spec DOCX deliverables in Drive

## Goal

Confirm that all three discovery documents exist in the client's Drive deliverables folder, are current to the latest markdown sources, and contain no financial information. Each document was uploaded inline as it was written (brief at step 3, PRD at step 5, tech spec at step 8) — this step is the final gate before the discovery digest goes out.

## What to verify

| Document | Expected filename | Drive destination |
|---|---|---|
| `spec/project-brief.md` | `<Client>-<Project>-Brief-v<X.Y>.docx` | Onboarding Shared Drive → `<Client Full Business Name>/deliverables/` |
| `spec/prd.md` | `<Client>-<Project>-PRD-v<X.Y>.docx` | Onboarding Shared Drive → `<Client Full Business Name>/deliverables/` |
| `spec/tech-spec.md` | `<Client>-<Project>-Tech-Spec-v<X.Y>.docx` | Onboarding Shared Drive → `<Client Full Business Name>/deliverables/` |

## Verification checks (run all three)

**1. All three DOCXs exist in Drive with correct filenames.**

Use `mcp__claude_ai_Google_Drive__search_files` to confirm each file is present in the client's `deliverables/` folder:

```
query: "name contains '<Client>-<Project>' and '<deliverables-folder-id>' in parents"
```

If any file is missing, generate and upload it now:

```bash
pandoc spec/<source>.md \
  -o /tmp/<slug>-<Doc>-v<X.Y>.docx \
  --from markdown --to docx
```

Then upload via `mcp__claude_ai_Google_Drive__create_file`.

**2. No DOCX files in the repo.**

```bash
git ls-files | grep '\.docx$'
find . -name '*.docx' -not -path './.git/*'
```

Both must return nothing. If a stray DOCX is found, `git rm` it.

**3. No financial information in any DOCX.**

Open each file and search for `$`, "deposit", "invoice", "pricing", "budget", "payment". If found in the markdown source, fix it, regenerate the DOCX, and re-upload.

## If a document is out of date

If the markdown source changed after the DOCX was uploaded (e.g., a post-grill PRD revision or a tech spec amendment), regenerate and replace:

```bash
pandoc spec/<source>.md -o /tmp/<new-filename>.docx --from markdown --to docx
```

Upload the new version via Drive MCP, then delete or trash the prior version. Do not leave both in Drive.

## Don't do this

- **Don't regenerate all three if only one changed.** Only replace files that are out of sync with their markdown source.
- **Don't upload to the repo or to local `Client Docs/`.** Drive is the destination.
- **Don't skip the version in the filename.** Always include `-v<X.Y>`.
- **Don't convert `GRILL_SESSION.md` or other internal-only files.** Internal reasoning does not go to the client.

## Done when

- All three DOCXs exist in the client's `deliverables/` folder in the Onboarding Shared Drive
- Filenames match the markdown sources' version frontmatter
- No DOCX in the repo
- No stale prior-version DOCX in Drive
- No financial information in any file

Move to step 12 (discovery digest) — that step links to these Drive files in the `#po` message.
