# Desktop Troubleshooting

Runbook for when the desktop breaks. Readable from a TTY (`less ~/.dotfiles/TROUBLESHOOTING.md`)
or pasteable into Claude on a phone.

## Context block (paste this first when asking for help)

```
System: Arch Linux, Hyprland 0.56 (Lua config, launched via uwsm), RTX 4080 with
nvidia-open-dkms, sbctl Secure Boot + GRUB (re-signed by pacman hook).
Login: greetd -> a minimal Hyprland greeter (/etc/greetd/hyprland-greeter.lua) running regreet.
Config: ~/.dotfiles/hypr/.config/hypr/hyprland.lua + lua/ modules (stow-managed);
hyprmod GUI writes ~/.config/hypr/hyprland-gui.lua (loaded last, not in dotfiles).
Monitor: DP-3, 3840x2160 @ scale 1.5.
```

## First: get a shell

- Black screen / frozen session: `Ctrl+Alt+F3`, log in. `claude` works in a TTY.
- No network in the TTY: `nmtui`.
- Get back to the graphical session: `Ctrl+Alt+F1` (greetd is on VT 1).

## Black screen after an update

Most likely: NVIDIA userspace and the loaded kernel module don't match.

```bash
modinfo -F version nvidia       # driver version in the installed module
cat /sys/module/nvidia/version  # driver version actually loaded
pacman -Q nvidia-utils nvidia-open-dkms linux
```

If the versions differ, **reboot**. Every time pacman upgrades `nvidia*` or `linux`,
the hook `/etc/pacman.d/hooks/zz-reboot-reminder.hook` prints a red "REBOOT NOW" warning.
In Wayland, `yu` warns and asks before running `yay -Syu` when such updates are pending.

If it still fails after a reboot, check that DKMS built the module for the running kernel:

```bash
dkms status
uname -r
journalctl -b -p err
```

## Red error banner at the top of the screen

That's Hyprland's config error overlay.

1. `hyprctl reload`. If the banner disappears, it was stale: the config was fixed after
   Hyprland loaded it (e.g. hyprmod created `hyprland-gui.lua` after login).
2. If it stays: `hyprctl configerrors` shows the current errors.
3. `module 'hyprland-gui' not found`: `hyprland-gui.lua` is missing. Create an empty one:
   `touch ~/.config/hypr/hyprland-gui.lua`, then `hyprctl reload`.
4. Validate a file without applying it: `Hyprland --verify-config -c <file>`.

Since 0.55, `hyprctl dispatch` takes Lua: `hyprctl dispatch 'hl.dsp.exit()'`.
The old `hyprctl dispatch exit` fails silently.

## Login screen problems (greetd)

- Greeter log: `/tmp/greetd-hyprland.log`
- Session log after login: `journalctl -b _UID=1000`
- greetd reads `/etc/greetd/config.toml` only at start; reboot (or restart greetd from a TTY) after editing it.
- Bypass the greeter: log in on a TTY and run `uwsm start hyprland.desktop`.

## Where logs live

| What | Where |
|---|---|
| Current Hyprland session | `$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log` |
| Hyprland from a TTY (no env vars) | `ls -t /run/user/1000/hypr/*/hyprland.log \| head -1` |
| Previous boot errors | `journalctl -b -1 -p err` |
| Recent package changes | `grep -E 'upgraded|installed' /var/log/pacman.log \| tail -30` |

Normal noise in the Hyprland log: `No CRTC 0`, `Wayland backend cannot start`,
`Creating the Error Overlay`, and libinput debounce lines.

## Rolling back a package

```bash
ls /var/cache/pacman/pkg/ | grep nvidia-utils
sudo pacman -U /var/cache/pacman/pkg/<package>-<old-version>.pkg.tar.zst
```

Roll back `nvidia-utils`, `lib32-nvidia-utils` and `nvidia-open-dkms` together, to the same version.

## Collect info to send to Claude

```bash
{ uname -r; cat /sys/module/nvidia/version; pacman -Q nvidia-utils nvidia-open-dkms linux hyprland;
  journalctl -b -1 -p err --no-pager | tail -50; tail -50 /tmp/greetd-hyprland.log;
  grep -E 'upgraded|installed' /var/log/pacman.log | tail -20; } > ~/debug.txt 2>&1
```

Then photograph the screen or copy `~/debug.txt` to the phone.
