#!/bin/bash
# Symlinks the Claude desktop app's bundled CLI binary onto PATH so `claude`
# works in a normal terminal. Re-run this after the desktop app auto-updates
# if the symlink ever goes stale.
set -e

CANDIDATE=$(ls -d "$HOME"/.config/Claude/claude-code/*/ 2>/dev/null | sort -V | tail -1)

if [ -z "$CANDIDATE" ] || [ ! -x "${CANDIDATE}claude" ]; then
  echo "Could not find a bundled claude binary under ~/.config/Claude/claude-code/ — open the Claude desktop app at least once first."
  exit 1
fi

mkdir -p "$HOME/.local/bin"
ln -sf "${CANDIDATE}claude" "$HOME/.local/bin/claude"
echo "Linked $HOME/.local/bin/claude -> ${CANDIDATE}claude"
