# ubuntu-to-mac-os-package

`./install.sh` into mac easily. Reproduces the macOS-Tahoe-styled Ubuntu/GNOME
desktop setup built up in a Claude Code session. Run once on a fresh Ubuntu
GNOME install:

```
bash install.sh
```

Then log out and back in — GNOME needs a fresh session to fully activate newly
installed shell extensions.

## What's included

- `scripts/01-packages.sh` — apt packages (gnome-sushi for Quick Look-style
  previews, fonts-inter, nodejs/npm) and Sober (Flathub) for Roblox.
- `scripts/02-theme.sh` — clones and installs the MacTahoe GTK theme, icon
  theme, and cursors from vinceliuice's official repos (canonical upstream
  source, not a snapshot — this generates variants correctly).
- `scripts/03-extensions.sh` — installs all GNOME Shell extensions (apt-bundled
  ones + store ones via the official install mechanism) and loads every
  setting that was tuned this session (dock behavior, animations, panel
  layout, notification position, day/night theme switching, etc.) from the
  `dconf/*.ini` dumps.
- `scripts/04-launchers.sh` — installs the `~/.local/bin/*.sh` app-launcher
  scripts (Claude/Spotify/Firefox) and fixes `~/.bashrc` so `~/.local/bin` is
  on PATH in ordinary terminal windows, not just login shells.
- `scripts/05-firefox-theme.sh` — installs macFox-theme (Tahoe UI variant)
  into whatever Firefox profile is current, auto-detected (works for both the
  Firefox snap and a regular install).
- `scripts/06-claude-cli.sh` — symlinks the Claude desktop app's bundled CLI
  binary onto PATH. Re-run this specific script (not the whole install) if it
  ever goes stale after the desktop app auto-updates.
- `scripts/07-extension-patches.sh` — overwrites specific files inside four
  extensions with real bug fixes found in use (see "Extension patches"
  below). Full-file replacements, not diffs, since patch context drifts
  across extension versions.
- `scripts/08-uncap-workspaces.sh` — raises GNOME's hard-coded 36-workspace
  ceiling. Needs `sudo` since it edits a system schema file directly.

## Extension patches

Real bugs found in third-party extensions during use, fixed by replacing the
affected file outright (see `patches/`):

- **compiz-windows-effect (wobbly windows)** — `vfunc_modify_paint_volume`
  was a stub always returning `false`, so GNOME Shell never expanded the
  window's paintable area to fit the wobble deformation; anything the spring
  physics pushed past the window's original rectangle got clipped. Also
  disables any `Rounded Corners Effect` on the actor for the duration of the
  wobble — a corner-clipping shader and a deformation effect fight each other
  by nature, regardless of which rounded-corners extension is used.
- **compiz-alike-magic-lamp-effect (minimize animation)** — `toTheBorder` was
  hardcoded `true`, forcing the animation to always fly to the literal
  monitor edge once it detected the icon was near a screen border, even when
  the dock was fully visible partway up from that edge. Set to `false`.
- **dash2dock-lite** — `integrations.js` computed the minimize-animation
  target's size as a hardcoded `0` (the real values were commented out in the
  original code), collapsing "center of icon" to "top-left corner of icon."
  Now uses the dock's actual current icon size (`dock._iconSizeScaledDown`).
  `dock.js` — the invisible `struts` widget (exists purely to reserve layout
  space, no interactive purpose) had no explicit `affectsInputRegion: false`,
  so on this GNOME version it defaulted to capturing clicks meant for
  windows/desktop underneath, at the bottom of the screen, dock visible or
  not. The surrounding code even had commented-out attempts at this same fix
  left unfinished.
- **desktop-cube** — its own preferences window had no way to control
  workspace count at all, despite the cube requiring a fixed count to render
  correctly. Added a "Workspaces" group (dynamic-workspaces toggle + a
  fixed-count spinner bound directly to the real system settings) to its
  prefs page.

## Keybindings set up

- `Super+Shift+C` → Claude desktop app
- `Super+Shift+S` → Spotify
- `Super+Shift+F` → Firefox

## Not included on purpose

- Anything from `~/Downloads` or other personal files/documents — this only
  covers system configuration, not your data.
- The disk-cleanup work from earlier in the session (deleting old Timeshift
  snapshots, moving Downloads to external storage) — that was one-time
  cleanup specific to a full disk, not general setup worth replaying blindly
  on a fresh machine with different free space.
- The Windows-side `tracker-dashboard` project import — unrelated to desktop
  theming, and already lives at `~/tracker-dashboard`.
- Liquid Glass shell extension — tried it, you didn't like it, removed.
- Rounded Window Corners Reborn — removed after it turned out to fundamentally
  conflict with the wobbly-windows effect (see "Extension patches").
- The logo-menu extension's custom icon was reset to default rather than
  carried over (it was pointing at an offensive image in your Downloads).
- Several extensions present on the live desktop this was packaged from
  (a weather extension, a clipboard manager, CoverflowAltTab, a lockscreen
  clock/customizer, a fan-control applet) — those were added independently,
  are unrelated to "make Ubuntu look like macOS," and this script has no
  install step for them. Add them yourself via the Extensions app if wanted.

## Notes

- `scripts/03-extensions.sh`'s `InstallRemoteExtension` calls may need a
  manual confirmation click the first time, or may need re-running once
  logged in with a full graphical session — GNOME's live extension
  installation flow was flaky in the original session (worked for
  store-installed extensions via this exact method, did not work for a
  manually-placed local extension).
- The MacTahoe theme install script (`scripts/02-theme.sh`) uses the default
  color variant. Run `~/.themes` or the cloned repo's `install.sh --help`
  yourself if you want a different accent color.
- The `dconf/*.ini` files use `__HOME__` as a placeholder anywhere an absolute
  home-directory path is needed (launcher script locations, wallpaper paths).
  `scripts/03-extensions.sh` substitutes it for your real `$HOME` at load
  time, so this works for any user on any machine.
- `scripts/08-uncap-workspaces.sh` edits a file owned by the
  `gsettings-desktop-schemas` package directly (GSettings override files can
  only change defaults, not the allowed `<range>`). Any OS/package update
  that reinstalls that file resets the cap back to 36 — just re-run the
  script if that happens.
