#!/bin/bash
set -euo pipefail

if command -v blueman-manager >/dev/null 2>&1; then
    exec blueman-manager
fi

if command -v ghostty >/dev/null 2>&1 && command -v bluetoothctl >/dev/null 2>&1; then
    exec ghostty -e bluetoothctl
fi

notify-send "Waybar" "No Bluetooth manager found (blueman-manager/bluetoothctl)."
