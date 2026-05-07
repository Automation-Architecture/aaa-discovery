# Step 8 — Update specs with team feedback

## Goal

Apply the `#next` team's feedback to the brief and PRD. Bump versions to reflect the substantive update. Regenerate the DOCX files.

## What constitutes a substantive update

Bump versions when the feedback caused real changes — scope shifts, decision reversals, terminology corrections, new constraints, removed sections. Don't bump for typo fixes or cosmetic edits.

- Brief: v1.0 → v1.1
- PRD: v1.0 → v1.1

## What to update in the documents

- The "Date" / "Version" header at the top of each doc — note this is the post-team-feedback revision
- Any section the team flagged. Be honest about reversals — if the team said "drop the safety classifier," the docs should explicitly say "Per `#next` team feedback, no safety classifier in v1" rather than silently removing it.
- The deliverables sequence in the brief — mark step 7 ✅ done, step 8 ✅ done.
- A new "Resolved Items (post `#next` team feedback round)" section that lists what was decided

## Regenerate DOCX

After committing the markdown changes, regenerate both DOCX files with the new version in the filename:

```bash
pandoc spec/project-brief.md -o "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<Client>-<Project>-Project-Brief-v1.1.docx" --from markdown --to docx
pandoc spec/prd.md -o "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<Client>-<Project>-PRD-v1.1.docx" --from markdown --to docx

# Delete the old versioned files so they don't accumulate
rm -f "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<Client>-<Project>-Project-Brief-v1.0.docx"
rm -f "/Users/brad/Documents/aaa/Client Docs/<Client>/prd/<slug>/<Client>-<Project>-PRD-v1.0.docx"
```

## Don't do this

- **Don't quietly skip feedback you disagree with.** If the team made a recommendation you think is wrong, say so explicitly in the next sync. Don't ghost it.
- **Don't bump versions without regenerating the DOCX.** Version mismatches between the markdown and the DOCX cause confusion downstream.
- **Don't keep old DOCX files.** Delete them after the new version generates cleanly.

## Verify before moving on

- Brief markdown reflects the feedback, version bumped
- PRD markdown reflects the feedback, version bumped
- New DOCX files generated; old DOCX files deleted
- Discovery sequence in the brief shows step 7 + 8 ✅ done

## Done when

Team feedback is visibly incorporated and the docs are at the new version. Move to step 9.
