#!/bin/bash
# GNOME Shell extensions — performance variant.
# Skips the GPU-heavy animated extensions (desktop-cube, the two compiz-alike
# effects, dash2dock-lite) and uses the built-in ubuntu-dock instead. See
# dconf/org-gnome-shell-performance.ini for the accompanying blur-my-shell
# fix (the stock dash-to-dock blur settings were tuned for dash2dock-lite's
# floating pill; used on ubuntu-dock as-is they under-blur and don't override
# the dock's own background, producing two mismatched translucent layers).
set -e

echo "==> Installing apt-packaged extensions (Ubuntu bundle, includes ubuntu-dock + user-theme)..."
sudo apt-get install -y gnome-shell-ubuntu-extensions gnome-shell-extension-user-theme

echo "==> Installing store extensions via GNOME's official install mechanism..."
# This triggers the normal extensions.gnome.org install flow for each UUID.
# Deliberately excludes: desktop-cube, compiz-alike-magic-lamp-effect,
# compiz-windows-effect, dash2dock-lite (animated / continuously-composited,
# expensive on weaker GPUs).
STORE_UUIDS=(
  just-perfection-desktop@just-perfection
  Vitals@CoreCoding.com
  blur-my-shell@aunetx
  rounded-window-corners@fxgn
  notification-position@drugo.dev
  nightthemeswitcher@romainvigier.fr
  logomenu@aryan_k
)

for uuid in "${STORE_UUIDS[@]}"; do
  echo "  Installing $uuid ..."
  gdbus call --session \
    --dest org.gnome.Shell.Extensions \
    --object-path /org/gnome/Shell/Extensions \
    --method org.gnome.Shell.Extensions.InstallRemoteExtension \
    "$uuid" || echo "  (may need a manual confirmation click, or a re-run after login)"
done

echo "==> Loading saved enabled/disabled extension state + all extension settings..."
DCONF_DIR="$(dirname "$0")/../dconf"
declare -A DCONF_PATHS=(
  [org-gnome-shell-performance.ini]="/org/gnome/shell/"
  [org-gnome-shell-extensions-just-perfection.ini]="/org/gnome/shell/extensions/just-perfection/"
  [org-gnome-shell-extensions-nightthemeswitcher.ini]="/org/gnome/shell/extensions/nightthemeswitcher/"
  [org-gnome-shell-extensions-notification-position.ini]="/org/gnome/shell/extensions/notification-position/"
  [org-gnome-shell-extensions-user-theme.ini]="/org/gnome/shell/extensions/user-theme/"
  [org-gnome-shell-extensions-ding.ini]="/org/gnome/shell/extensions/ding/"
  [org-gnome-desktop-interface.ini]="/org/gnome/desktop/interface/"
  [org-gnome-desktop-wm-preferences.ini]="/org/gnome/desktop/wm/preferences/"
  [org-gnome-desktop-background.ini]="/org/gnome/desktop/background/"
  [org-gnome-settings-daemon-plugins-media-keys.ini]="/org/gnome/settings-daemon/plugins/media-keys/"
)
for fname in "${!DCONF_PATHS[@]}"; do
  sed "s#__HOME__#$HOME#g" "$DCONF_DIR/$fname" | dconf load "${DCONF_PATHS[$fname]}"
done

echo "03-extensions-performance.sh done. Log out and back in for everything to fully activate (new extensions need a fresh session scan)."
