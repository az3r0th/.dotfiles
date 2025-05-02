local Terminal = require("toggleterm.terminal").Terminal

-- Create a new terminal instance
local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
        border = "double",
    },
})

-- Function to toggle lazygit
local function _lazygit_toggle()
    lazygit:toggle()
end

-- Create a new terminal instance for regular terminal
local regular_term = Terminal:new({
    direction = "float",
    float_opts = {
        border = "double",
    },
})

-- Function to toggle regular terminal
local function _regular_term_toggle()
    regular_term:toggle()
end

-- Export the functions
return {
    lazygit_toggle = _lazygit_toggle,
    regular_term_toggle = _regular_term_toggle,
} 