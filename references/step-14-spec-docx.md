# Step 14 — Generate spec DOCX deliverables into Client Docs

## Goal

Every spec markdown source is rendered to a polished DOCX in `Client Docs/<Client Full Business Name>/`. This is the step that produces the deliverables the operator attaches to the client email (step 15). By making it a dedicated step, you guarantee the DOCX files are **current** to the latest markdown sources — not stale from earlier in the flow when the brief or PRD got version-bumped after team feedback.

This step also enforces the global rule that DOCX deliverables live **only** in `Client Docs/<Client>/`, never in the repo.

## What gets converted

The canonical three:

| Source (markdown in repo) | Output (DOCX in Client Docs) |
|---|---|
| `spec/project-brief.md` (or `PROJECT_BRIEF.md`) | `Client Docs/<Client>/brief/<Client>-<Project>-Brief-v<X.Y>.docx` |
| `spec/prd.md` (or `PRD.md`) | `Client Docs/<Client>/prd/<slug>/<Client>-<Project>-PRD-v<X.Y>.docx` |
| `spec/tech-spec.md` | `Client Docs/<Client>/prd/<slug>/<Client>-<Project>-Tech-Spec-v<X.Y>.docx` |

(The exact folder layout under `Client Docs/<Client>/` varies per engagement — some use `prd/<slug>/`, some use a flat `prd/`. Check the per-project memory for the established convention before you start. Match it; don't introduce a new layout mid-engagement.)

## What does NOT get converted

- **`spec/GRILL_SESSION.md`** — internal grilling artifact; never goes to the client. Same for any Round 2 / architecture grill files.
- **`spec/design-handoff-brief.md`** or other internal-only docs — operator decision per project.
- **Addenda** (e.g., `spec/prd_addendum_<project>.md`) — convert only if the operator marks it client-facing. By default, addenda are folded into the PRD and don't ship as separate DOCX.

When in doubt: would the operator hand this to the client as a standalone document? If yes, convert. If no, skip.

## Pandoc command pattern

Per the global CLAUDE.md rule, pandoc writes **straight to Client Docs**, never to the repo first.

```bash
cd ~/Documents/aaa/client_projects/<initials>/repo/<project>/spec

pandoc project-brief.md \
  -o "/Users/brad/Documents/aaa/Client Docs/<Client>/brief/<Client>-<Project>-Brief-v1.0.docx" \
  --from markdown --to docx

pandoc prd.md \
  -o "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<Client>-<Project>-PRD-v1.0.docx" \
  --from markdown --to docx

pandoc tech-spec.md \
  -o "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<Client>-<Project>-Tech-Spec-v1.0.docx" \
  --from markdown --to docx
```

Substitute `<Client>` (full business name), `<Project>`, `<slug>`, and `<X.Y>` (version, matching what's in the markdown source's frontmatter).

If `Client Docs/<Client>/<area>/` doesn't exist, create it first. The full client name → initials mapping lives in per-project memory.

## Version bump discipline

The DOCX filename's version must match the markdown source's version frontmatter. If you bumped the PRD from v1.1 to v1.2 after the tech-spec step, the DOCX must be `<Client>-<Project>-PRD-v1.2.docx`.

**Replace, don't accumulate.** When you bump from v1.1 to v1.2, delete the v1.1 DOCX from `Client Docs/<Client>/prd/<slug>/` after confirming v1.2 exists. Stale DOCX files in Client Docs cause the operator to attach an old version to the client email by mistake.

```bash
# After v1.2 is confirmed:
rm "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<Client>-<Project>-PRD-v1.1.docx"
```

## Verifications (run all three)

1. **Each expected DOCX exists at its target path.**
   ```bash
   ls -la "/Users/brad/Documents/aaa/Client Docs/<Client>/brief/" \
          "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/"
   ```

2. **No DOCX files in the repo.**
   ```bash
   cd ~/Documents/aaa/client_projects/<initials>/repo/<project>
   git ls-files | grep '\.docx$'   # must return nothing
   find . -name '*.docx' -not -path './node_modules/*' -not -path './.git/*'   # must also return nothing
   ```
   If a stray DOCX is found in the repo, `git rm` it after confirming the Client Docs copy is current. This is a recurring pitfall (see SKILL.md common pitfalls).

3. **No financial information bled into the DOCX.** Open each generated DOCX and search for `$`, "deposit", "invoice", "pricing", "budget", "payment". Tech docs must never contain financial content (global rule). If found in the markdown, fix the markdown source, regenerate the DOCX.

## Don't do this

- **Don't generate to the repo first and `cp` to Client Docs.** Pandoc writes straight there. The repo never sees a DOCX.
- **Don't convert `GRILL_SESSION.md` or other internal-only files.** Client doesn't need them; they often contain candid internal reasoning, version-dump-style decisions, or rep names that don't belong in client deliverables.
- **Don't skip the version in the filename.** `<Client>-<Project>-PRD.docx` (no version) makes it impossible to tell which version is current. Always include `-v<X.Y>`.
- **Don't accumulate vintage versions.** Old DOCX in Client Docs creates ambiguity at the email step. Replace, don't add.
- **Don't include financial info.** Same global rule. If the markdown has it, remove it from the source first, then convert.

## Done when

- Brief, PRD, and tech-spec DOCX all exist at their target paths in `Client Docs/<Client>/`
- Filenames match the markdown sources' versions
- No DOCX in the repo
- No prior-version DOCX still sitting in Client Docs
- All three files open cleanly in Word/Pages without rendering errors

Move to step 15 (client email) — that step references these DOCX paths directly.
