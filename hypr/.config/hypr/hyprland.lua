-- Hyprland Lua config
-- https://wiki.hypr.land/Configuring/Start/

local cfg_dir = os.getenv("HOME") .. "/.config/hypr/lua/"
package.path = cfg_dir .. "?.lua;" .. package.path

require("env")
require("monitors")
require("appearance")
require("input")
require("rules")
require("keybinds")
require("autostart")
require("hyprland-gui")
