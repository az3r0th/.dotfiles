#!/bin/sh
# Get global X position
cursor_x=$(hyprctl cursorpos -j | python3 -c "import json,sys; print(json.load(sys.stdin)['x'])" 2>/dev/null || echo 0)

# Waybar sets WAYBAR_OUTPUT_NAME if it's HDMI-A-1, DP-3 etc.
case "$WAYBAR_OUTPUT_NAME" in
    "HDMI-A-1") monitor_id=0 ;;
    "DP-3") monitor_id=1 ;;
    *) 
        # Fallback to cursor position if not called from Waybar or unknown output
        monitor_id=$(hyprctl monitors -j | python3 -c "import json,sys; 
monitors = json.load(sys.stdin)
cursor_x = float(sys.argv[1])
for m in monitors:
    if m['x'] <= cursor_x < m['x'] + m['width']:
        print(m['id'])
        sys.exit(0)
print(monitors[0]['id'])" "$cursor_x" 2>/dev/null || echo 0)
        ;;
esac

ags -i media-popup request toggle-media "$cursor_x" "$monitor_id"
