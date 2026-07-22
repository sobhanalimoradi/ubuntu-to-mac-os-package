#!/bin/bash
# Ptyxis terminal: custom palette + transparency
set -e

echo "==> Installing custom 'Tahoe Night' palette for Ptyxis..."
mkdir -p "$HOME/.local/share/org.gnome.Ptyxis/palettes"
cp "$(dirname "$0")/../config/tahoe-night.palette" "$HOME/.local/share/org.gnome.Ptyxis/palettes/"

echo "==> Applying palette + transparency to the default profile..."
PROFILE_UUID=$(dconf read /org/gnome/Ptyxis/default-profile-uuid | tr -d "'")
if [ -z "$PROFILE_UUID" ]; then
  echo "Could not find a Ptyxis profile — open Ptyxis once first, then re-run this script."
  exit 1
fi
dconf write "/org/gnome/Ptyxis/Profiles/$PROFILE_UUID/palette" "'tahoe-night'"
dconf write "/org/gnome/Ptyxis/Profiles/$PROFILE_UUID/opacity" "0.9"

echo "09-terminal.sh done. Open a new Ptyxis window to see it."
echo "(Optional: sudo apt-get install fonts-jetbrains-mono for a nicer coding font.)"
