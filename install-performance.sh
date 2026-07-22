#!/bin/bash
# Performance variant: same macOS-Tahoe theming as install.sh, but skips the
# GPU-heavy animated GNOME Shell extensions (desktop cube, magic lamp, compiz
# windows effect) in favor of plain dash-to-dock. See
# scripts/03-extensions-performance.sh and dconf/org-gnome-shell-performance.ini.
# Run from a normal terminal: bash install-performance.sh
set -e
cd "$(dirname "$0")"

bash scripts/00-trim-autostart.sh
bash scripts/00-zram.sh
bash scripts/01-packages.sh
bash scripts/02-theme.sh
bash scripts/03-extensions-performance.sh
bash scripts/04-launchers.sh
bash scripts/05-firefox-theme.sh
bash scripts/06-claude-cli.sh || echo "(skipped claude CLI symlink — open the Claude desktop app once, then run scripts/06-claude-cli.sh)"
bash scripts/08-uncap-workspaces.sh
bash scripts/09-terminal.sh || echo "(skipped terminal palette — open Ptyxis once, then run scripts/09-terminal.sh)"

echo
echo "=================================================="
echo "Done. Now:"
echo "  1. Log out and back in (new GNOME extensions need a fresh session to activate)."
echo "  2. Open GNOME Settings > Appearance and confirm Dark style + MacTahoe-Dark theme."
echo "  3. Open Firefox once (closed) so the theme prefs take effect."
echo "=================================================="
