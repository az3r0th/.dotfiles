#!/usr/bin/env python3
"""Hyprland gamepad daemon — polls evdev controller, dispatches hyprctl commands."""

import subprocess
import time
from evdev import InputDevice, ecodes, list_devices

# Axis dead zone (0-32767 range, stick center = 0)
DEAD_ZONE = 8000
# Repeat delay for held buttons (seconds)
REPEAT_DELAY = 0.15
# Analog stick repeat rate when held past dead zone
STICK_RATE = 0.12

def find_gamepad():
    for path in list_devices():
        dev = InputDevice(path)
        caps = dev.capabilities()
        # Gamepad has both buttons and absolute axes (sticks)
        if ecodes.EV_ABS in caps and ecodes.EV_KEY in caps:
            keys = caps.get(ecodes.EV_KEY, [])
            # Must have BTN_SOUTH (A button) — standard gamepad marker
            if ecodes.BTN_SOUTH in keys:
                return dev
    return None

def run(args):
    subprocess.Popen(args, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def dispatch(lua_expr):
    # Hyprland 0.55+: hyprctl dispatch takes a Lua dispatcher expression
    run(["hyprctl", "dispatch", lua_expr])

def focus(d):
    return f'hl.dsp.focus({{ direction = "{d}" }})'

def move(d):
    return f'hl.dsp.window.move({{ direction = "{d}" }})'

# --- Button → action map ---
# Standard Linux evdev codes (Xbox/PS/generic all map here via kernel driver)
BUTTON_ACTIONS = {
    ecodes.BTN_SOUTH:  lambda: run(["rofi", "-show", "drun"]),   # A  → launcher
    ecodes.BTN_EAST:   lambda: dispatch("hl.dsp.window.close()"),            # B  → close window
    ecodes.BTN_NORTH:  lambda: run(["ghostty"]),                  # Y  → terminal
    ecodes.BTN_WEST:   lambda: run(["zen-browser"]),              # X  → browser
    ecodes.BTN_START:  lambda: run(["rofi", "-show", "drun"]),   # Start → launcher
    ecodes.BTN_SELECT: lambda: dispatch('hl.dsp.window.float({ action = "toggle" })'),        # Select → float toggle
    ecodes.BTN_TL:     lambda: dispatch('hl.dsp.focus({ workspace = "e-1" })'),         # LB → prev workspace
    ecodes.BTN_TR:     lambda: dispatch('hl.dsp.focus({ workspace = "e+1" })'),         # RB → next workspace
    ecodes.BTN_TL2:    lambda: dispatch('hl.dsp.focus({ workspace = "e-1" })'),         # LT → prev workspace
    ecodes.BTN_TR2:    lambda: dispatch('hl.dsp.focus({ workspace = "e+1" })'),         # RT → next workspace
    ecodes.BTN_THUMBL: lambda: dispatch('hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'),          # L3 → fullscreen toggle
    ecodes.BTN_THUMBR: lambda: dispatch("hl.dsp.window.pseudo()"),                # R3 → pseudo tile
}

# D-pad hat codes
DPAD_X = ecodes.ABS_HAT0X  # -1=left, +1=right
DPAD_Y = ecodes.ABS_HAT0Y  # -1=up,   +1=down

# Left stick axes
LS_X = ecodes.ABS_X
LS_Y = ecodes.ABS_Y

# Right stick axes
RS_X = ecodes.ABS_RX
RS_Y = ecodes.ABS_RY

def main():
    print("Hyprland gamepad daemon starting...", flush=True)

    while True:
        dev = find_gamepad()
        if not dev:
            print("No gamepad found, retrying in 3s...", flush=True)
            time.sleep(3)
            continue

        print(f"Found gamepad: {dev.name} at {dev.path}", flush=True)

        # Track axis states for analog repeat
        axis_state = {}
        axis_last_fire = {}
        btn_held = {}

        try:
            for event in dev.read_loop():
                now = time.monotonic()

                # --- Button press ---
                if event.type == ecodes.EV_KEY:
                    code = event.code
                    if event.value == 1:  # press
                        btn_held[code] = now
                        action = BUTTON_ACTIONS.get(code)
                        if action:
                            action()
                    elif event.value == 0:  # release
                        btn_held.pop(code, None)

                # --- Absolute axes (sticks + dpad) ---
                elif event.type == ecodes.EV_ABS:
                    axis = event.code
                    val  = event.value
                    axis_state[axis] = val

                    # D-pad: discrete, fire on each state change
                    if axis == DPAD_X:
                        if val == -1:
                            dispatch(focus("left"))
                        elif val == 1:
                            dispatch(focus("right"))

                    elif axis == DPAD_Y:
                        if val == -1:
                            dispatch(focus("up"))
                        elif val == 1:
                            dispatch(focus("down"))

                # --- Analog stick repeat loop (non-blocking via select timeout) ---
                # Handled below in a separate tick pass via monotonic checks

                # Analog stick firing (runs each event loop iteration)
                for ax, direction, neg_act, pos_act in [
                    (LS_X, axis_state.get(LS_X, 0), focus("left"), focus("right")),
                    (LS_Y, axis_state.get(LS_Y, 0), focus("up"), focus("down")),
                    (RS_X, axis_state.get(RS_X, 0), move("left"), move("right")),
                    (RS_Y, axis_state.get(RS_Y, 0), move("up"), move("down")),
                ]:
                    if abs(direction) > DEAD_ZONE:
                        last = axis_last_fire.get(ax, 0)
                        if now - last >= STICK_RATE:
                            axis_last_fire[ax] = now
                            dispatch(neg_act if direction < 0 else pos_act)
                    else:
                        axis_last_fire.pop(ax, None)

        except OSError:
            print("Gamepad disconnected, searching again...", flush=True)
            time.sleep(1)

if __name__ == "__main__":
    main()
