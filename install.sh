#!/bin/bash
# Reproduces the macOS-Tahoe-styled Ubuntu/GNOME setup on a fresh install.
# Run from a normal terminal: bash install.sh
set -e
cd "$(dirname "$0")"

bash scripts/00-zram.sh
bash scripts/00-trim-autostart.sh
bash scripts/01-packages.sh
bash scripts/02-theme.sh
bash scripts/03-extensions.sh
bash scripts/04-launchers.sh
bash scripts/05-firefox-theme.sh
bash scripts/06-claude-cli.sh || echo "(skipped claude CLI symlink — open the Claude desktop app once, then run scripts/06-claude-cli.sh)"

echo
echo "=================================================="
echo "Done. Now:"
echo "  1. Log out and back in (new GNOME extensions need a fresh session to activate)."
echo "  2. Open GNOME Settings > Appearance and confirm Dark style + MacTahoe-Dark theme."
echo "  3. Open Firefox once (closed) so the theme prefs take effect."
echo "=================================================="
