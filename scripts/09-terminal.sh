#!/bin/bash
# Terminal: Ptyxis custom palette + transparency, plus a fastfetch splash
# (Apple logo + system info) on every new interactive shell.
set -e

echo "==> Installing custom 'Tahoe Night' palette for Ptyxis..."
mkdir -p "$HOME/.local/share/org.gnome.Ptyxis/palettes"
cp "$(dirname "$0")/../config/tahoe-night.palette" "$HOME/.local/share/org.gnome.Ptyxis/palettes/"

echo "==> Applying palette + transparency to the default profile..."
PROFILE_UUID=$(dconf read /org/gnome/Ptyxis/default-profile-uuid | tr -d "'")
if [ -z "$PROFILE_UUID" ]; then
  echo "Could not find a Ptyxis profile — open Ptyxis once first, then re-run this script."
else
  dconf write "/org/gnome/Ptyxis/Profiles/$PROFILE_UUID/palette" "'tahoe-night'"
  dconf write "/org/gnome/Ptyxis/Profiles/$PROFILE_UUID/opacity" "0.9"
fi

echo "==> Installing fastfetch (system-info splash with an Tux penguin logo)..."
sudo apt-get install -y fastfetch
mkdir -p "$HOME/.config/fastfetch"
cp "$(dirname "$0")/../config/fastfetch-config.jsonc" "$HOME/.config/fastfetch/config.jsonc"

if ! grep -q "fastfetch" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<'EOF'

# show a system-info splash on every new interactive terminal
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi
EOF
fi

echo "09-terminal.sh done. Open a new terminal window to see it."
echo "(Optional: sudo apt-get install fonts-jetbrains-mono for a nicer coding font.)"
