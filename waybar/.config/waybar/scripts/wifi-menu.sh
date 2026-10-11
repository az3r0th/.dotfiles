#!/bin/bash
set -euo pipefail

if command -v nm-connection-editor >/dev/null 2>&1; then
    exec nm-connection-editor
fi

if command -v ghostty >/dev/null 2>&1 && command -v nmtui >/dev/null 2>&1; then
    exec ghostty -e nmtui
fi

notify-send "Waybar" "No Wi-Fi manager found (nm-connection-editor/nmtui)."
