hl.config({
    cursor = {
        no_hardware_cursors = 1,
    },

    general = {
        gaps_in         = 4,
        gaps_out        = 4,
        border_size     = 3,
        col = {
            active_border   = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = true,
        allow_tearing    = true,
        layout           = "hyprscrolling",
    },

    decoration = {
        rounding         = 15,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 3,
            render_power = 2,
            color        = "rgba(00000088)",
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 1,
            vibrancy          = 0.2,
            new_optimizations = true,
            xray              = false,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper      = 0,
        disable_hyprland_logo        = true,
        focus_on_activate            = true,
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
        disable_splash_rendering     = false,
        animate_manual_resizes       = true,
        animate_mouse_windowdragging = true,
        enable_swallow               = true,
        swallow_regex                = "^(ghostty)$",
        swallow_exception_regex      = "^(wev)$",
        vrr                          = 1,
    },
})

-- Bezier curves
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("linear",   { type = "bezier", points = { { 0,    0   }, { 1,   1    } } })
hl.curve("wind",     { type = "bezier", points = { { 0.05, 0.9 }, { 0,   1    } } })
hl.curve("winIn",    { type = "bezier", points = { { 0.1,  1.1 }, { 0.1, 1.1  } } })
hl.curve("winOut",   { type = "bezier", points = { { 0.3, -0.3 }, { 0,   1    } } })
hl.curve("slow",     { type = "bezier", points = { { 0,   0.85 }, { 0.3, 1    } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.22, 1 }, { 0.36, 1 } } })
hl.curve("easeInCubic",  { type = "bezier", points = { { 0.55, 0 }, { 1,    0.45 } } })

-- Animations
hl.animation({ leaf = "windows",          enabled = true, speed = 6,  bezier = "wind"   })
hl.animation({ leaf = "windowsIn",        enabled = true, speed = 6,  bezier = "winIn"  })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 5,  bezier = "winOut" })
hl.animation({ leaf = "windowsMove",      enabled = true, speed = 5,  bezier = "wind"   })
hl.animation({ leaf = "fade",             enabled = true, speed = 10, bezier = "slow"   })
hl.animation({ leaf = "fadeIn",           enabled = true, speed = 3,  bezier = "winIn"  })
hl.animation({ leaf = "fadeOut",          enabled = true, speed = 3,  bezier = "winOut" })
hl.animation({ leaf = "fadeSwitch",       enabled = true, speed = 5,  bezier = "slow"   })
hl.animation({ leaf = "fadeShadow",       enabled = true, speed = 5,  bezier = "slow"   })
hl.animation({ leaf = "fadeDim",          enabled = true, speed = 4,  bezier = "slow"   })
hl.animation({ leaf = "border",           enabled = true, speed = 6,  bezier = "wind"   })
hl.animation({ leaf = "borderangle",      enabled = false })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5,  bezier = "wind"   })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5,  bezier = "winIn"  })
-- Layer surfaces (waybar peek, rofi, swaync): decelerate in, accelerate out
hl.animation({ leaf = "layersIn",         enabled = true, speed = 2,   bezier = "easeOutQuint" })
hl.animation({ leaf = "layersOut",        enabled = true, speed = 1.5, bezier = "easeInCubic"  })
hl.animation({ leaf = "fadeLayersIn",     enabled = true, speed = 2,   bezier = "easeOutQuint" })
hl.animation({ leaf = "fadeLayersOut",    enabled = true, speed = 1.5, bezier = "easeInCubic"  })
