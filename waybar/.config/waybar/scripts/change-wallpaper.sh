#!/bin/bash

WALLPAPER_DIR="$HOME/Wallpapers"
MONITORS=$(hyprctl monitors | grep 'Monitor' | awk '{print $2}')

for MON in $MONITORS; do
    WP=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

    if [[ -f "$WP" ]]; then
        hyprctl hyprpaper preload "$WP"
        hyprctl hyprpaper wallpaper "$MON,$WP"
    fi
done
