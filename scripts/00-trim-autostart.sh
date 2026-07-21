#!/bin/bash
# Disables background services that run on every login but aren't part of
# the desktop or theme: Evolution's reminder-popup daemon (nobody's using
# Evolution), the update-notifier tray icon, and gnome-software. Independent
# of the theme, but this script runs first (before any apt-get calls) so
# gnome-software is masked before it can ever be triggered.
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
pkill -f evolution-alarm-notify 2>/dev/null || true
pkill -f update-notifier 2>/dev/null || true

# gnome-software is D-Bus-activated: PackageKit fires a "cache changed"
# signal after every single apt-get/dpkg operation (see
# /etc/apt/apt.conf.d/20packagekit), and gnome-software responds by
# re-resolving its whole app catalog — a 10+ minute CPU spike on weak
# hardware. Since this repo's own scripts run several apt-get installs
# back-to-back, that spike would otherwise fire repeatedly on every install
# run. Masked, not just stopped, since D-Bus activation would otherwise
# relaunch it on the next PackageKit signal. Reversible:
# systemctl --user unmask gnome-software.service
systemctl --user mask gnome-software.service
systemctl --user stop gnome-software.service 2>/dev/null || true

echo "00-trim-autostart.sh done."
