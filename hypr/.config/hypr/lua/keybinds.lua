local p = require("programs")
local mod = p.mainMod

-- Apps
hl.bind(mod .. " + Return",        hl.dsp.exec_cmd(p.terminal))
hl.bind(mod .. " + Q",             hl.dsp.window.close())
hl.bind(mod .. " + B",             hl.dsp.exec_cmd(p.browser))
hl.bind(mod .. " + E",             hl.dsp.exec_cmd(p.fileManager))
hl.bind(mod .. " + V",             hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + space",         hl.dsp.exec_cmd(p.menu))
hl.bind(mod .. " + C",             hl.dsp.exec_cmd('rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo -n \'\\{result\\}\' | wl-copy"'))
hl.bind(mod .. " + P",             hl.dsp.window.pseudo())
hl.bind(mod .. " + W",             hl.dsp.exec_cmd(p.reloadWaybar))
hl.bind(mod .. " + SHIFT + I",     hl.dsp.exec_cmd(p.colorPicker))
hl.bind(mod .. " + CTRL + Q",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + ALT + E",       hl.dsp.exec_cmd(p.emojiPicker))
hl.bind(mod .. " + ALT + C",       hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))
hl.bind("CTRL + ALT + space",      hl.dsp.exec_cmd("claude-desktop"))

-- Focus (l/r/u/d direction)
hl.bind(mod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Move window
hl.bind(mod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

-- Resize (x/y/relative)
hl.bind(mod .. " + ALT + h", hl.dsp.window.resize({ x = -20, y =   0, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT + l", hl.dsp.window.resize({ x =  20, y =   0, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT + k", hl.dsp.window.resize({ x =   0, y = -20, relative = true }), { repeating = true })
hl.bind(mod .. " + ALT + j", hl.dsp.window.resize({ x =   0, y =  20, relative = true }), { repeating = true })

-- Fullscreen
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Workspaces 1–10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Workspace scroll/arrows
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + left",       hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + right",      hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))

-- Mouse drag/resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- DPMS (timer-wrapped per wiki recommendation)
hl.bind(mod .. " + CTRL + P", function()
    hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "disable" })) end, { timeout = 100, type = "oneshot" })
end)
hl.bind(mod .. " + CTRL + SHIFT + P", function()
    hl.timer(function() hl.dispatch(hl.dsp.dpms({ action = "enable" })) end, { timeout = 100, type = "oneshot" })
end)

-- Misc
hl.bind(mod .. " + R",         hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + SHIFT + C", hl.dsp.window.center())
hl.bind("ALT + Tab",           hl.dsp.window.cycle_next({ next = true }))
hl.bind("ALT + SHIFT + Tab",   hl.dsp.window.cycle_next({ next = false }))
hl.bind(mod .. " + G",         hl.dsp.group.toggle())
hl.bind(mod .. " + Tab",       hl.dsp.group.next())

-- Monitor input toggle
hl.bind("SUPER + CTRL + ALT + X", hl.dsp.exec_cmd("~/.config/waybar/scripts/monitor-input.sh toggle"))

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("ddcutil setvcp 10 + 10"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("ddcutil setvcp 10 - 10"), { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

-- Screenshots
hl.bind("SUPER + CTRL + 3",             hl.dsp.exec_cmd("hyprcap shot monitor:active -c -W -n -A"))
hl.bind("SUPER + CTRL + 4",             hl.dsp.exec_cmd("hyprcap shot region -c -W -n -A"))
hl.bind("SUPER + CTRL + 5",             hl.dsp.exec_cmd("hyprcap shot window:active -c -W -n -A"))
hl.bind("SUPER + CTRL + SHIFT + 3",     hl.dsp.exec_cmd("hyprcap shot monitor:active -w -n -A"))
hl.bind("SUPER + CTRL + SHIFT + 4",     hl.dsp.exec_cmd("hyprcap shot region -w -n -A"))
hl.bind("SUPER + CTRL + SHIFT + 5",     hl.dsp.exec_cmd("hyprcap shot window:active -w -n -A"))

-- Screen recording
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprcap rec monitor:active -w -n -A"))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprcap rec -stop -n -A"))

-- Wallpaper
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.config/awww/scripts/wall-select.sh"))
