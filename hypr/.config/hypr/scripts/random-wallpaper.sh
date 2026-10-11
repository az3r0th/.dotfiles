#!/bin/bash

wallpapers="$HOME/Wallpapers"
random_wall=$(find "$wallpapers" -type f | shuf -n 1)

cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = $random_wall
wallpaper = ,$random_wall
EOF

#hyprpaper
