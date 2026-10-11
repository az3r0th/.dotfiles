#!/bin/bash
# Outputs the active window's app icon (Nerd Font) as JSON for Waybar.
# Listens to Hyprland's event socket via ncat for real-time updates.

get_icon() {
    case "${1,,}" in  # lowercase match
        firefox*|librewolf*)           echo "󰈹" ;;
        brave*)                        echo "" ;;
        chromium*)                     echo "" ;;
        google-chrome*)                echo "" ;;
        cursor*)                       echo "󰨞" ;;
        code|vscodium*)                echo "󰨞" ;;
        kitty*)                        echo "" ;;
        ghostty*)                      echo "" ;;
        alacritty*)                    echo "" ;;
        foot*)                         echo "" ;;
        wezterm*)                      echo "" ;;
        discord*|vesktop*)             echo "󰙯" ;;
        telegram*)                     echo "" ;;
        slack*)                        echo "󰒱" ;;
        spotify*)                      echo "" ;;
        vlc*)                          echo "󰕼" ;;
        mpv*)                          echo "" ;;
        thunar*|nautilus*|pcmanfm*)    echo "󰉋" ;;
        steam*)                        echo "󰓓" ;;
        lutris*)                       echo "" ;;
        gimp*)                         echo "" ;;
        inkscape*)                     echo "" ;;
        obs*)                          echo "󰐌" ;;
        pavucontrol*)                  echo "󰕾" ;;
        obsidian*)                     echo "󱓧" ;;
        notion*)                       echo "" ;;
        "")                            echo "󰇄" ;;
        *)                             echo "󱂬" ;;
    esac
}

emit() {
    local class="$1"
    local icon
    icon=$(get_icon "$class")
    printf '{"text":"%s","tooltip":"%s"}\n' "$icon" "$class"
}

# Emit initial state
class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty')
emit "$class"

# Listen to Hyprland event socket for live updates
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
ncat -U "$socket" 2>/dev/null | while IFS= read -r line; do
    event="${line%%>>*}"
    case "$event" in
        activewindow|focusedmon)
            class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // empty')
            emit "$class"
            ;;
    esac
done
