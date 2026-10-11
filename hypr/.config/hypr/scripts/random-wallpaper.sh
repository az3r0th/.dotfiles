#!/bin/bash
set -euo pipefail

wallpapers="${HOME}/Wallpapers"

if [[ ! -d "${wallpapers}" ]]; then
  exit 1
fi

random_wall="$(
  find "${wallpapers}" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) \
    | shuf -n 1
)"

if [[ -z "${random_wall}" ]]; then
  exit 1
fi

if ! pgrep -x awww-daemon >/dev/null 2>&1; then
  awww-daemon &
  sleep 0.5
fi

awww img "${random_wall}" \
  --transition-type grow \
  --transition-pos 0.5,0.5 \
  --transition-duration 1.5
