#!/bin/bash
# GNOME hard-caps workspaces at 36 via a <range> in the system schema itself.
# GSettings override files can only change defaults, not ranges, so the only
# way to actually raise this is editing the schema file directly. This will
# get reset to 36 by any OS/package update that reinstalls this file — just
# re-run this script if that happens.
set -e

SCHEMA_FILE=/usr/share/glib-2.0/schemas/org.gnome.desktop.wm.preferences.gschema.xml
NEW_MAX=100

sudo sed -i "s/<range min=\"1\" max=\"36\"\/>/<range min=\"1\" max=\"$NEW_MAX\"\/>/" "$SCHEMA_FILE"
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

echo "08-uncap-workspaces.sh done. num-workspaces can now go up to $NEW_MAX."
