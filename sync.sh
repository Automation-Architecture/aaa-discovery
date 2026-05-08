#!/usr/bin/env bash
#
# Sync this repo's skill files into the Claude Code runtime install at
# ~/.claude/skills/aaa-discovery/. Run after editing SKILL.md, references/,
# or templates/.
#
# Usage:
#   ./sync.sh              # sync (overwrites runtime install)
#   ./sync.sh --dry-run    # show what would change without touching files

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.claude/skills/aaa-discovery"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

DRY_RUN=""
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN="--dry-run"
  echo -e "${YELLOW}DRY RUN — no files will be changed${NC}"
fi

mkdir -p "$INSTALL_DIR"

# Sync skill files only — exclude repo metadata and human-facing docs.
rsync -av --delete \
  --exclude='.git' \
  --exclude='README.md' \
  --exclude='docs' \
  --exclude='sync.sh' \
  --exclude='.gitignore' \
  ${DRY_RUN} \
  "${REPO_ROOT}/" "${INSTALL_DIR}/"

if [[ -z "${DRY_RUN}" ]]; then
  echo
  echo -e "${GREEN}✓ Synced to ${INSTALL_DIR}${NC}"
  echo "  Restart Claude Code so the skill reloads."
fi
