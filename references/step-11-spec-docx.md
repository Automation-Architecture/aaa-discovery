# Step 11 — Generate spec DOCX deliverables and upload to Drive

## Goal

Every spec markdown source is rendered to a DOCX and uploaded to the client's folder in the Onboarding Shared Drive. This is the step that produces the deliverables referenced in the step 12 discovery digest. By making it a dedicated step, you guarantee the DOCX files are **current** to the latest markdown sources.

## What gets converted

The canonical three:

| Source (markdown in repo) | Output filename | Drive destination |
|---|---|---|
| `spec/project-brief.md` | `<Client>-<Project>-Brief-v<X.Y>.docx` | Onboarding Shared Drive → `<Client Full Business Name>/deliverables/` |
| `spec/prd.md` | `<Client>-<Project>-PRD-v<X.Y>.docx` | Onboarding Shared Drive → `<Client Full Business Name>/deliverables/` |
| `spec/tech-spec.md` | `<Client>-<Project>-Tech-Spec-v<X.Y>.docx` | Onboarding Shared Drive → `<Client Full Business Name>/deliverables/` |

## What does NOT get converted

- **`spec/GRILL_SESSION.md`** — internal grilling artifact; never goes to the client.
- Internal-only docs — operator decision per project.
- Addenda — convert only if the operator marks them client-facing.

When in doubt: would the operator hand this to the client as a standalone document? If yes, convert. If no, skip.

## How to generate and upload

Generate each DOCX locally to `/tmp/`, then upload via the Google Drive MCP.

```bash
cd ~/Documents/aaa/client_projects/<initials>/repo/<project>/spec

pandoc project-brief.md -o /tmp/<slug>-Brief-v1.0.docx --from markdown --to docx
pandoc prd.md           -o /tmp/<slug>-PRD-v1.0.docx   --from markdown --to docx
pandoc tech-spec.md     -o /tmp/<slug>-Tech-Spec-v1.0.docx --from markdown --to docx
```

Then for each file, upload via Google Drive MCP:

```
mcp__claude_ai_Google_Drive__create_file(
  name: "<Client>-<Project>-Brief-v1.0.docx",
  parent_folder_id: "<client-deliverables-folder-id>",
  local_path: "/tmp/<slug>-Brief-v1.0.docx"
)
```

**Finding the client deliverables folder ID:** Search the Onboarding Shared Drive (`0AOk2FIY4h-9gUk9PVA`) for `<Client Full Business Name>`. If a `deliverables/` subfolder doesn't exist yet, create it first with `mcp__claude_ai_Google_Drive__create_file` (folder type). Save the folder ID to project memory.

## Version bump discipline

The DOCX filename's version must match the markdown source's version frontmatter. If you bumped the PRD from v1.1 to v1.2, the upload must be named `<Client>-<Project>-PRD-v1.2.docx`.

**Replace, don't accumulate.** When you bump a version, delete or trash the prior version in Drive after confirming the new one uploaded cleanly. Stale DOCX files in Drive create version ambiguity when referenced in the step 12 digest.

## Verifications (run all three)

1. **Each expected DOCX exists in the client's Drive deliverables folder.** Use `mcp__claude_ai_Google_Drive__search_files` to confirm all three files are present with the correct names.

2. **No DOCX files in the repo.**
   ```bash
   cd ~/Documents/aaa/client_projects/<initials>/repo/<project>
   git ls-files | grep '\.docx$'
   find . -name '*.docx' -not -path './.git/*'
   ```
   Both must return nothing. If a stray DOCX is found, `git rm` it.

3. **No financial information in any DOCX.** Open each file and search for `$`, "deposit", "invoice", "pricing", "budget", "payment". If found in the markdown, fix the source, regenerate, re-upload.

## Don't do this

- **Don't upload to the repo or to local `Client Docs/`.** Drive is the destination for discovery deliverables.
- **Don't convert `GRILL_SESSION.md` or other internal-only files.** They contain internal reasoning that doesn't belong in client deliverables.
- **Don't skip the version in the filename.** Always include `-v<X.Y>`.
- **Don't accumulate old versions in Drive.** Replace, don't add.
- **Don't include financial info.** Fix the markdown source first, then regenerate.

## Done when

- Brief, PRD, and tech-spec DOCX all exist in the client's `deliverables/` folder in the Onboarding Shared Drive
- Filenames match the markdown sources' versions
- No DOCX in the repo
- No prior-version DOCX still in Drive
- All three files open cleanly in Word/Pages

Move to step 12 (discovery digest) — that step links to these Drive files in the `#po` message.
