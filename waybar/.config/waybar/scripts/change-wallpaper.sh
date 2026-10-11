#!/bin/bash

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Wallpapers}"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    notify-send "Waybar" "Wallpaper dir not found: $WALLPAPER_DIR"
    exit 1
fi

MONITORS=$(hyprctl monitors 2>/dev/null | grep 'Monitor' | awk '{print $2}')
[[ -z "$MONITORS" ]] && exit 1

for MON in $MONITORS; do
    WP=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | shuf -n 1)
    [[ -z "$WP" || ! -f "$WP" ]] && continue

    hyprctl hyprpaper preload "$WP"
    hyprctl hyprpaper wallpaper "$MON,$WP"
done
