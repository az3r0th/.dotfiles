#!/usr/bin/env sh
set -eu

out_dir="$HOME/Pictures/Screenshots"
log_file="$out_dir/.screenshot.log"
/usr/bin/mkdir -p "$out_dir"
file="$out_dir/$(/usr/bin/date +%Y-%m-%d_%H-%M-%S)_window.png"

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

geom="$(hyprctl activewindow -j 2>>"$log_file" | /usr/bin/jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
[ -n "$geom" ] || exit 0

if /usr/bin/grim -g "$geom" "$file" 2>>"$log_file"; then
  /usr/bin/wl-copy < "$file" || true
  /usr/bin/notify-send "Screenshot" "Window saved: $file"
else
  /usr/bin/notify-send "Screenshot Failed" "Check $log_file"
fi
