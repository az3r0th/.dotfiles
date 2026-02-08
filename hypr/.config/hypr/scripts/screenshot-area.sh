#!/usr/bin/env sh
set -eu

out_dir="$HOME/Pictures/Screenshots"
log_file="$out_dir/.screenshot.log"
/usr/bin/mkdir -p "$out_dir"
file="$out_dir/$(/usr/bin/date +%Y-%m-%d_%H-%M-%S).png"

# Try sane defaults if env is incomplete when launched from a keybind.
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

geom="$(/usr/bin/slurp 2>>"$log_file")"
[ -n "$geom" ] || exit 0

if /usr/bin/grim -g "$geom" "$file" 2>>"$log_file"; then
  /usr/bin/wl-copy < "$file" || true
  /usr/bin/notify-send "Screenshot" "Area saved: $file"
else
  /usr/bin/notify-send "Screenshot Failed" "Check $log_file"
fi
