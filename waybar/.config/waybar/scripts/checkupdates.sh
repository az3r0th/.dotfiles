#!/bin/bash

# Check for pacman updates
pacman_updates=$(checkupdates 2>/dev/null | wc -l)

# Check for AUR updates if yay is installed
if command -v yay &> /dev/null; then
    aur_updates=$(yay -Qu 2>/dev/null | wc -l)
    total_updates=$((pacman_updates + aur_updates))
else
    total_updates=$pacman_updates
fi

# Output in JSON format for Waybar
if [ "$total_updates" -gt 0 ]; then
    echo "{\"text\": \"󰏔 $total_updates\", \"tooltip\": \"$pacman_updates pacman + $aur_updates AUR updates available\", \"class\": \"updates-available\"}"
else
    echo "{\"text\": \"󰏔\", \"tooltip\": \"System is up to date\", \"class\": \"updates-none\"}"
fi 