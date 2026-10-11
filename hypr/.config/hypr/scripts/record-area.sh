#!/usr/bin/env sh
set -eu

PID_FILE="/tmp/wf-recorder-area.pid"

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  kill -SIGINT "$(cat "$PID_FILE")"
  rm -f "$PID_FILE"
  /usr/bin/notify-send "Recording" "Stopped and saved"
else
  geom="$(/usr/bin/slurp)" || exit 0

  out_dir="$HOME/Videos/Recordings"
  /usr/bin/mkdir -p "$out_dir"
  file="$out_dir/$(/usr/bin/date +%Y-%m-%d_%H-%M-%S)_area.mp4"

  wf-recorder -g "$geom" -f "$file" &
  echo $! > "$PID_FILE"
  /usr/bin/notify-send "Recording" "Started (area): $file"
fi
