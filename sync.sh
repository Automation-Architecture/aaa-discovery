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
RED='\033[0;31m'
NC='\033[0m'

DRY_RUN=""
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN="--dry-run"
  echo -e "${YELLOW}DRY RUN — no files will be changed${NC}"
fi

mkdir -p "${INSTALL_DIR}"

# SAFETY: resolve symlinks on both sides and refuse to run if they point to the
# same physical directory. Without this guard, an install dir that's a symlink
# back into this repo (directly or via a chain) causes rsync --delete-excluded
# to delete the source's excluded files (.git, README.md, docs/, sync.sh) — an
# unrecoverable wipe of the repo's local state if not pushed. Lost the local
# git history this way once; never again.
SRC_REAL="$(cd "${REPO_ROOT}" && pwd -P)"
DST_REAL="$(cd "${INSTALL_DIR}" && pwd -P)"
if [[ "${SRC_REAL}" == "${DST_REAL}" ]]; then
  echo -e "${RED}ABORT: source and destination resolve to the same physical path:${NC}"
  echo "  ${SRC_REAL}"
  echo
  echo "The install dir (${INSTALL_DIR}) is likely a symlink back into this repo,"
  echo "directly or via a chain. Make it a real directory before syncing:"
  echo "  rm \"${INSTALL_DIR}\" && mkdir \"${INSTALL_DIR}\""
  exit 1
fi

# Sync skill files only — exclude repo metadata and human-facing docs.
# --delete removes files in dest that aren't in source.
# --delete-excluded also removes files in dest that match exclude patterns,
# so excluded files don't linger from earlier syncs that didn't exclude them.
rsync -av --delete --delete-excluded \
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
