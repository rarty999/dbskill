#!/bin/bash
# Bridge repo .dbs/ to ~/.dbs/ so dbs-save / dbs-restore can persist snapshots
# across Claude Code on the web sessions via this git repo.
set -euo pipefail

# Only run in remote (web) environment to avoid clobbering local ~/.dbs
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

REPO_DBS="${CLAUDE_PROJECT_DIR:-$(pwd)}/.dbs"
HOME_DBS="$HOME/.dbs"

mkdir -p "$REPO_DBS/sessions"

# If ~/.dbs is already the correct symlink, nothing to do
if [ -L "$HOME_DBS" ] && [ "$(readlink "$HOME_DBS")" = "$REPO_DBS" ]; then
  exit 0
fi

# If ~/.dbs exists as a real dir with content (shouldn't happen in fresh container,
# but be defensive), merge it into the repo dir before linking
if [ -d "$HOME_DBS" ] && [ ! -L "$HOME_DBS" ]; then
  if [ -n "$(ls -A "$HOME_DBS" 2>/dev/null)" ]; then
    cp -rn "$HOME_DBS"/. "$REPO_DBS"/ 2>/dev/null || true
  fi
  rm -rf "$HOME_DBS"
fi

ln -snf "$REPO_DBS" "$HOME_DBS"
