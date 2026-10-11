#!/usr/bin/env python3
"""Show waybar while the cursor touches a monitor's top edge, hide it when the cursor leaves.

OLED burn-in guard: the bar stays hidden unless you reach for it.
Requires in waybar config: "start_hidden": true, "on-sigusr1": "show", "on-sigusr2": "hide".
"""
import fcntl
import json
import os
import signal
import socket
import subprocess
import time

REVEAL_PX = 2      # cursor within this many px of a monitor's top edge -> show
HIDE_PX = 64       # cursor further than this below the top edge -> start hide timer
HIDE_DELAY = 0.3   # seconds the cursor must stay away before hiding
POLL = 0.05        # seconds between cursor checks
MONITOR_REFRESH = 5.0

SOCK = os.path.join(
    os.environ["XDG_RUNTIME_DIR"], "hypr",
    os.environ["HYPRLAND_INSTANCE_SIGNATURE"], ".socket.sock",
)


def hypr(cmd):
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.connect(SOCK)
        s.sendall(cmd.encode())
        chunks = []
        while data := s.recv(65536):
            chunks.append(data)
    return json.loads(b"".join(chunks))


def monitor_top(monitors, x, y):
    """Return the logical top edge of the monitor under (x, y), or None."""
    for m in monitors:
        w, h = m["width"] / m["scale"], m["height"] / m["scale"]
        if m["transform"] % 2:
            w, h = h, w
        if m["x"] <= x < m["x"] + w and m["y"] <= y < m["y"] + h:
            return m["y"]
    return None


def waybar(sig):
    subprocess.run(["pkill", f"-{sig}", "-x", "waybar"], check=False)


def main():
    # Single instance: a second copy exits instead of polling alongside the first
    lock = open(os.path.join(os.environ["XDG_RUNTIME_DIR"], "waybar-peek.lock"), "w")
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        return

    signal.signal(signal.SIGTERM, lambda *_: (waybar("USR1"), exit(0)))
    shown = False
    away_since = None
    monitors, monitors_at = [], 0.0
    waybar("USR2")  # start from a known state

    while True:
        try:
            now = time.monotonic()
            if now - monitors_at > MONITOR_REFRESH:
                monitors, monitors_at = hypr("j/monitors"), now
            pos = hypr("j/cursorpos")
        except (OSError, ValueError):
            if not os.path.exists(SOCK):
                return  # Hyprland is gone
            time.sleep(1)
            continue

        top = monitor_top(monitors, pos["x"], pos["y"])
        rel = None if top is None else pos["y"] - top

        if not shown:
            if rel is not None and rel <= REVEAL_PX:
                waybar("USR1")
                shown, away_since = True, None
        elif rel is None or rel > HIDE_PX:
            away_since = away_since or now
            if now - away_since >= HIDE_DELAY:
                waybar("USR2")
                shown, away_since = False, None
        else:
            away_since = None

        time.sleep(POLL)


if __name__ == "__main__":
    main()
