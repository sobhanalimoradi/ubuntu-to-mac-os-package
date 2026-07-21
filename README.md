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

`install.sh` is the uncompromised version — every extension, including the
animated ones (desktop cube, magic lamp workspace switch, compiz windows
effect) and the dash2dock-lite floating dock.

`install-performance.sh` drops those four animated extensions and uses
`scripts/03-extensions-performance.sh` instead of `scripts/03-extensions.sh`.
Since dash2dock-lite is gone, it falls back to `ubuntu-dock@ubuntu.com` (ships
with `gnome-shell-ubuntu-extensions`, already apt-installed either way — no
extra package needed). That fallback dock previously looked bugged/glitchy
whenever it wasn't paired with dash2dock-lite: the checked-in blur-my-shell
settings for the dash (`sigma=3`, `static-blur=false`,
`override-background=false`) were essentially inert leftovers, so the dock's
own semi-opaque background (`background-opacity=0.8`) showed through
un-blurred instead of getting the frosted-glass treatment — two mismatched
translucent layers stacked on top of each other. `dconf/org-gnome-shell-performance.ini`
fixes this: `override-background=true` + `static-blur=true` + `sigma=24` let
blur-my-shell fully own the dock's background (so `background-opacity` is set
to `0.0`), using the rounded pipeline that matches the dock's floating-pill
shape (`extend-height=false`). The panel and dash also switch from dynamic to
static blur (computed once instead of every frame), and overview/appfolder/
application-grid blur are turned off — those recompute continuously while
animating and are the most GPU-expensive part of blur-my-shell.

## What's included

- `scripts/01-packages.sh` — apt packages (gnome-sushi for Quick Look-style
  previews, fonts-inter, nodejs/npm, flatpak) and Sober (Flathub) for Roblox.
  Recent Ubuntu releases no longer ship Flatpak preinstalled, so `flatpak` and
  `gnome-software-plugin-flatpak` are installed explicitly before the Flathub
  remote is added.
- `scripts/02-theme.sh` — clones and installs the MacTahoe GTK theme, icon
  theme, and cursors from vinceliuice's official repos (canonical upstream
  source, not a snapshot — this generates variants correctly).
- `scripts/03-extensions.sh` — installs all GNOME Shell extensions (apt-bundled
  ones + store ones via the official install mechanism) and loads every
  setting that was tuned this session (dock behavior, animations, panel
  layout, notification position, day/night theme switching, etc.) from the
  `dconf/*.ini` dumps. Used by `install.sh`.
- `scripts/03-extensions-performance.sh` — same idea, but skips
  desktop-cube, compiz-alike-magic-lamp-effect, compiz-windows-effect, and
  dash2dock-lite, and loads `dconf/org-gnome-shell-performance.ini` instead
  (ubuntu-dock + the blur fix described above). Used by
  `install-performance.sh`.
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
