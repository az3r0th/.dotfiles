hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:escape",
        kb_rules   = "",

        follow_mouse              = 1,
        mouse_refocus             = true,
        float_switch_override_focus = 2,
        sensitivity               = 0,
        accel_profile             = "flat",
        force_no_accel            = true,
        repeat_rate               = 50,
        repeat_delay              = 300,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
