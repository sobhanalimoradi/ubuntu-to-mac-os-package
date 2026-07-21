# ubuntu-to-mac-os-package

`./install.sh` into mac easily. Reproduces the macOS-Tahoe-styled Ubuntu/GNOME
desktop setup built up in a Claude Code session. Run once on a fresh Ubuntu
GNOME install:

```
bash install.sh
```

There's also a performance variant for weaker hardware — same theme, wallpapers
and layout, but without the GPU-heavy animated extensions:

```
bash install-performance.sh
```

Then log out and back in — GNOME needs a fresh session to fully activate newly
installed shell extensions.

## Normal vs. performance

`install.sh` is the uncompromised version — every extension, including
dash2dock-lite (a floating, custom-compositing dock) and compiz-windows-effect.

`install-performance.sh` drops those two (the heaviest, continuously-animated
ones) via `scripts/03-extensions-performance.sh` and uses the plain
`dash-to-dock@micxgx.gmail.com` extension instead — much cheaper, since it
doesn't run its own compositing pipeline every frame the way dash2dock-lite
does. desktop-cube and compiz-alike-magic-lamp-effect stay enabled in both
versions, since they only animate during their own transition rather than
continuously.

Switching off dash2dock-lite exposed a pre-existing bug: blur-my-shell's
dash-to-dock blur settings (`sigma=3`, `static-blur=false`,
`override-background=false`) were inert leftovers, so plain dash-to-dock's
own semi-opaque background (`background-opacity=0.8`) showed through
un-blurred instead of getting a frosted-glass look — a glitchy, mismatched
appearance. `dconf/org-gnome-shell-performance.ini` fixes it the simple way:
blur is turned off for the dash-to-dock component entirely (`blur=false`)
rather than patched, since the dock already looks clean on its own at
`background-opacity=0.8`.

This dconf file mirrors the configuration actually running and confirmed
working well on the original dev machine — captured directly via `dconf dump`
rather than reconstructed from scratch.

## What's included

- `scripts/01-packages.sh` — apt packages (gnome-sushi for Quick Look-style
  previews, fonts-inter, nodejs/npm, flatpak) and Sober (Flathub) for Roblox.
  Recent Ubuntu releases no longer ship Flatpak preinstalled, so `flatpak` and
  `gnome-software-plugin-flatpak` are installed explicitly before the Flathub
  remote is added.
- `scripts/02-theme.sh` — clones and installs the MacTahoe GTK theme, icon
  theme, and cursors from vinceliuice's official repos (canonical upstream
  source, not a snapshot — this generates variants correctly). Passes
  `-l`/`--libadwaita` so the theme also lands in `~/.config/gtk-4.0` — without
  it, GTK4/libadwaita apps (Settings, Files, Text Editor, ...) ignore
  `~/.themes` entirely and fall back to plain monochrome Adwaita window
  buttons instead of the macOS-style red/yellow/green traffic lights (which
  are real colored PNG assets baked into the theme, not a config toggle).
- `scripts/03-extensions.sh` — installs all GNOME Shell extensions (apt-bundled
  ones + store ones via the official install mechanism) and loads every
  setting that was tuned this session (dock behavior, animations, panel
  layout, notification position, day/night theme switching, etc.) from the
  `dconf/*.ini` dumps. Used by `install.sh`.
- `scripts/03-extensions-performance.sh` — same idea, but skips
  compiz-windows-effect and dash2dock-lite in favor of plain dash-to-dock, and
  loads `dconf/org-gnome-shell-performance.ini` instead (includes the blur fix
  described above). Used by `install-performance.sh`.
- `scripts/04-launchers.sh` — installs the `~/.local/bin/*.sh` app-launcher
  scripts (Claude/Spotify/Firefox) and fixes `~/.bashrc` so `~/.local/bin` is
  on PATH in ordinary terminal windows, not just login shells.
- `scripts/05-firefox-theme.sh` — installs macFox-theme (Tahoe UI variant)
  into whatever Firefox profile is current, auto-detected (works for both the
  Firefox snap and a regular install).
- `scripts/06-claude-cli.sh` — symlinks the Claude desktop app's bundled CLI
  binary onto PATH. Re-run this specific script (not the whole install) if it
  ever goes stale after the desktop app auto-updates.

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
- The logo-menu extension's custom icon was reset to default rather than
  carried over (it was pointing at an offensive image in your Downloads).

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
