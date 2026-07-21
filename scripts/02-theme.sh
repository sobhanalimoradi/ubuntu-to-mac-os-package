#!/bin/bash
# MacTahoe GTK theme, icon theme, and cursors (from the original, canonical source)
set -e

WORKDIR=$(mktemp -d)
cd "$WORKDIR"

echo "==> Cloning MacTahoe GTK theme..."
git clone --depth=1 https://github.com/vinceliuice/MacTahoe-gtk-theme.git
cd MacTahoe-gtk-theme
# -l/--libadwaita also writes the theme (incl. the red/yellow/green traffic-
# light window-button assets) into ~/.config/gtk-4.0. Without it, only
# ~/.themes gets the theme, which GTK4/libadwaita apps (Settings, Files, Text
# Editor, ...) ignore entirely — they'd fall back to plain monochrome Adwaita
# window buttons instead of the macOS-style colored dots. Must not run as root.
./install.sh -d "$HOME/.themes" -l

echo "==> Installing bundled day/night wallpapers..."
mkdir -p "$HOME/.local/share/backgrounds"
cp wallpaper/MacTahoe-day.jpeg wallpaper/MacTahoe-night.jpeg "$HOME/.local/share/backgrounds/"
cd ..

echo "==> Cloning MacTahoe icon theme (includes cursors)..."
git clone --depth=1 https://github.com/vinceliuice/MacTahoe-icon-theme.git
cd MacTahoe-icon-theme
./install.sh -d "$HOME/.local/share/icons"
cd ..

cd "$HOME"
rm -rf "$WORKDIR"

echo "02-theme.sh done. Run 'MacTahoe-gtk-theme/install.sh --help' or 'MacTahoe-icon-theme/install.sh --help' yourself if you want non-default color variants."
