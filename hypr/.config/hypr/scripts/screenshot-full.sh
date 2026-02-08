#!/usr/bin/env sh
set -eu

out_dir="$HOME/Pictures/Screenshots"
log_file="$out_dir/.screenshot.log"
/usr/bin/mkdir -p "$out_dir"
file="$out_dir/$(/usr/bin/date +%Y-%m-%d_%H-%M-%S).png"

# Try sane defaults if env is incomplete when launched from a keybind.
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

{
  echo "[$(/usr/bin/date '+%F %T')] full-shot start"
  echo "XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-}"
  echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"
} >>"$log_file"

geom="$(hyprctl monitors 2>>"$log_file" | awk '
/^Monitor / { name=$2; gsub(/\r/, "", name); mongeom="" }
/^[[:space:]]*[0-9]+x[0-9]+@[0-9.]+[[:space:]]+at[[:space:]]+[0-9]+x[0-9]+/ {
  split($1, a, "@")
  split(a[1], r, "x")
  split($3, p, "x")
  mongeom = p[1] "," p[2] " " r[1] "x" r[2]
}
/focused:[[:space:]]+yes/ {
  if (mongeom != "") { print mongeom; exit }
}
')"

if [ -n "$geom" ] && /usr/bin/grim -g "$geom" "$file" 2>>"$log_file"; then
  /usr/bin/wl-copy < "$file" || true
  /usr/bin/notify-send "Screenshot" "Saved (focused monitor): $file"
elif geom="$(/usr/bin/slurp -o 2>>"$log_file")" && [ -n "$geom" ] && /usr/bin/grim -g "$geom" "$file" 2>>"$log_file"; then
  /usr/bin/wl-copy < "$file" || true
  /usr/bin/notify-send "Screenshot" "Saved (output): $file"
else
  /usr/bin/notify-send "Screenshot Failed" "Check $log_file"
fi
