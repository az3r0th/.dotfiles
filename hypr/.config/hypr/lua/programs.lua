local M = {}

M.terminal    = "ghostty"
M.fileManager = "thunar"
M.menu        = "rofi -show drun"
M.browser     = "~/.config/hypr/scripts/open-browser.sh"
M.colorPicker = "hyprpicker -l -a"
M.emojiPicker = "rofi -modi emoji -show emoji"
M.screenshot  = "hyprcap shot"
M.screenRecord= "hyprcap rec"
M.reloadWaybar= "pkill waybar; waybar &"
M.mainMod     = "SUPER"

return M
