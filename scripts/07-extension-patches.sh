#!/bin/bash
# Fixes for real bugs found in third-party extensions during use. These are
# full-file replacements (not diffs) since patch context can drift across
# extension versions — must run AFTER scripts/03-extensions.sh.
set -e

PATCH_DIR="$(dirname "$0")/../patches"
EXT_DIR="$HOME/.local/share/gnome-shell/extensions"

echo "==> Patching compiz-windows-effect (wobbly windows):"
echo "    - vfunc_modify_paint_volume was a stub that always returned false,"
echo "      so the wobble deformation got clipped at the window's original"
echo "      rectangle. Now properly expands the paint volume."
echo "    - Disables any 'Rounded Corners Effect' on the actor for the"
echo "      duration of the wobble, since a corner-clip shader and a"
echo "      deformation effect fight each other."
cp "$PATCH_DIR/wobbly.js" "$EXT_DIR/compiz-windows-effect@hermes83.github.com/src/effects/wobbly.js"

echo "==> Patching compiz-alike-magic-lamp-effect (magic lamp minimize):"
echo "    - toTheBorder was hardcoded true, forcing the animation to always"
echo "      fly to the literal screen edge even when the dock is visible."
cp "$PATCH_DIR/magic-lamp-extension.js" "$EXT_DIR/compiz-alike-magic-lamp-effect@hermes83.github.com/extension.js"

echo "==> Patching desktop-cube preferences:"
echo "    - Adds a Workspaces group (dynamic-workspaces toggle + a fixed-count"
echo "      spinner) directly to the extension's own prefs window, since the"
echo "      cube needs a fixed workspace count and GNOME buries that control"
echo "      elsewhere."
cp "$PATCH_DIR/desktop-cube-prefs.js" "$EXT_DIR/desktop-cube@schneegans.github.com/prefs.js"

echo "==> Reloading patched extensions..."
for uuid in compiz-windows-effect@hermes83.github.com \
            compiz-alike-magic-lamp-effect@hermes83.github.com \
            desktop-cube@schneegans.github.com; do
  gnome-extensions disable "$uuid" 2>/dev/null || true
  sleep 1
  gnome-extensions enable "$uuid" 2>/dev/null || true
done

echo "07-extension-patches.sh done."
