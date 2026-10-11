local p = require("programs")

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/scripts/random-wallpaper.sh")
    hl.exec_cmd("swaync")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("playerctld daemon")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("waybar")
    -- OLED: reveal waybar only when cursor touches the top edge
    hl.exec_cmd("python3 ~/.config/hypr/scripts/waybar-peek.py")
    hl.exec_cmd("hypridle --config ~/.config/hypr/hypridle.conf")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd('openrgb --startminimized --profile "Correct"')
    hl.exec_cmd("warp-taskbar")
    -- Launch terminal silently on workspace 2
    hl.exec_cmd(p.terminal, { workspace = "2 silent" })
    -- Delayed reload to settle dynamic state
    hl.exec_cmd("sleep 3 && hyprctl reload")
    -- Gamepad daemon (auto-detects controller, reconnects on unplug)
    hl.exec_cmd("python3 ~/.config/hypr/scripts/gamepad-daemon.py")
end)
