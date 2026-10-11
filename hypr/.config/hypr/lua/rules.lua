-- Rofi blur
hl.layer_rule({
    name  = "blur-rofi",
    match = { namespace = "^(rofi)$" },
    blur  = true,
})

-- Waybar peek (OLED): slide down from top edge instead of popping in
hl.layer_rule({
    name      = "slide-waybar",
    match     = { namespace = "^(waybar)$" },
    animation = "slide top",
})

-- Tearing for fullscreen/games
hl.window_rule({
    name      = "tearing-fullscreen",
    match     = { fullscreen = true },
    immediate = true,
})

hl.window_rule({
    name      = "tearing-steam",
    match     = { class = "^(steam_app_.*)$" },
    immediate = true,
})

hl.window_rule({
    name      = "tearing-gamescope",
    match     = { class = "^(gamescope)$" },
    immediate = true,
})

-- App placement
hl.window_rule({
    name      = "place-terminal",
    match     = { class = "^(ghostty)$" },
    workspace = "2",
})

-- Claude: no decorations, fixed size, centered
hl.window_rule({
    name        = "claude-decor",
    match       = { class = "^(Claude)$" },
    decorate    = false,
    no_shadow   = true,
    border_size = 0,
})

hl.window_rule({
    name  = "claude-size",
    match = { class = "^(Claude)$" },
    size  = { 800, 600 },
})

hl.window_rule({
    name   = "claude-center",
    match  = { class = "^(Claude)$" },
    center = true,
})

-- JuhRadial MX overlay
hl.window_rule({
    name        = "juhradial-float",
    match       = { title = "^(JuhRadial MX)$" },
    float       = true,
    pin         = true,
    no_blur     = true,
    no_shadow   = true,
    no_anim     = true,
    border_size = 0,
})

-- Cloudflare One (WARP) client: floating, 750x625, centered
hl.window_rule({
    name   = "warp-float",
    match  = { class = "^(warp-taskbar)$" },
    float  = true,
    size   = { 750, 625 },
    center = true,
    suppress_event = "maximize",
})
