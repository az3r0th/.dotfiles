-- Primary monitor layout
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@75",  position = "0x0",    scale = 1, vrr = 0 })
hl.monitor({ output = "DP-3",     mode = "1920x1080@165", position = "1920x0", scale = 1, vrr = 0 })
hl.monitor({ output = "WAYLAND-1", disabled = true })

-- Fallback for renamed/hotplugged outputs
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Workspace -> monitor binding
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-3",     default = true })
