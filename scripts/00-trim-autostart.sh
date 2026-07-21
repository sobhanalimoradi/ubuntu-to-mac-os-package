#!/bin/bash
# Disables background services that run on every login but aren't part of
# the desktop or theme: Evolution's reminder-popup daemon (nobody's using
# Evolution) and the update-notifier tray icon. Pure per-user autostart
# overrides — no system files touched, no sudo needed, fully reversible by
# deleting the two files this writes. Independent of the theme.
set -e

mkdir -p "$HOME/.config/autostart"
for f in org.gnome.Evolution-alarm-notify update-notifier; do
  src="/etc/xdg/autostart/$f.desktop"
  dest="$HOME/.config/autostart/$f.desktop"
  if [[ -f "$src" ]] && [[ ! -f "$dest" ]]; then
    cp "$src" "$dest"
    echo "Hidden=true" >> "$dest"
    echo "  Disabled autostart: $f"
  fi
done

echo "00-trim-autostart.sh done. Restart, or kill the running instances now:"
echo "  pkill -f evolution-alarm-notify; pkill -f update-notifier"
