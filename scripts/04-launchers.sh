#!/bin/bash
# App launcher scripts + keybindings (Super+Shift+C/S/F) + PATH fix
set -e

echo "==> Installing launcher scripts to ~/.local/bin..."
mkdir -p "$HOME/.local/bin"
cp "$(dirname "$0")"/../bin/*.sh "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin"/*.sh

echo "==> Making sure ~/.local/bin is on PATH for normal (non-login) terminals..."
if ! grep -q 'HOME/.local/bin' "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<'EOF'

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
EOF
fi

echo "==> Custom keybindings (Super+Shift+C/S/F) load via the dconf dump in 03-extensions.sh"
echo "    (org-gnome-settings-daemon-plugins-media-keys.ini covers this)."

echo "04-launchers.sh done."
