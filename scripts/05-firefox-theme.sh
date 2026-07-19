#!/bin/bash
# macFox-theme (Tahoe UI variant) for Firefox
set -e

# Locate the default profile — handles both the Firefox snap and a regular install.
if [ -d "$HOME/snap/firefox/common/.mozilla/firefox" ]; then
  PROFILES_ROOT="$HOME/snap/firefox/common/.mozilla/firefox"
else
  PROFILES_ROOT="$HOME/.mozilla/firefox"
fi

PROFILE_REL=$(awk -F= '/^Path=/{print $2; exit}' "$PROFILES_ROOT/profiles.ini")
PROFILE="$PROFILES_ROOT/$PROFILE_REL"

if [ -z "$PROFILE_REL" ] || [ ! -d "$PROFILE" ]; then
  echo "Could not find a Firefox profile under $PROFILES_ROOT — run Firefox once first, then re-run this script."
  exit 1
fi

echo "==> Using Firefox profile: $PROFILE"

if [ -d "$PROFILE/chrome/.git" ]; then
  echo "==> macFox-theme already present, pulling latest..."
  git -C "$PROFILE/chrome" pull
else
  echo "==> Cloning macFox-theme..."
  git clone https://github.com/d0sse/macFox-theme.git "$PROFILE/chrome"
fi

echo "==> Writing required about:config prefs to user.js..."
cat > "$PROFILE/user.js" <<'EOF'
// Required for macFox-theme (userChrome.css customizations)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("browser.tabs.allow_transparent_browser", true);
user_pref("layout.css.color-mix.enabled", true);
user_pref("browser.theme.native-theme", true);
user_pref("userChrome.tahoeUI.enabled", true);
user_pref("browser.newtab.url", "about:blank");
user_pref("browser.newtabpage.enabled", false);
EOF

echo "05-firefox-theme.sh done. Firefox must be closed for these to take effect on first run."
