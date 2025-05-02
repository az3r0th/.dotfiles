-- General File Operations:
-- <leader>w  - Save current file
-- <leader>q  - Close current window
-- <leader>Q  - Close all windows
-- <leader>x  - Save and close current window
-- <leader>X  - Save and close all windows
-- <leader>q! - Force close current window without saving
-- <leader>Q! - Force close all windows without saving
-- <leader>c  - Close current buffer

-- Buffer Navigation:
-- <S-h>      - Switch to previous buffer
-- <S-l>      - Switch to next buffer

-- Search and Replace:
-- <leader>s  - Find and replace current word under cursor
-- <leader>S  - Find and replace with last search pattern
-- <leader>h  - Clear search highlights

-- File Explorer:
-- -          - Open parent directory in file explorer
-- <leader>e  - Open file explorer

-- Terminal:
-- <leader>tt - Toggle terminal
-- <leader>tg - Toggle lazygit

-- Command Mode:
-- ;          - Enter command mode
-- :          - Enter command mode

-- Help and Documentation:
-- <leader>?  - Open cheatsheet for keybindings
-- <leader>ch - Open cheatsheet for keybindings

-- Configuration:
-- <leader>rl - Reload Neovim configuration and sync plugins

-- Window Navigation (vim-tmux-navigator):
-- <c-h>      - Navigate left
-- <c-j>      - Navigate down
-- <c-k>      - Navigate up
-- <c-l>      - Navigate right
-- <c-\>      - Navigate to previous window

local keymap = vim.keymap.set

-- General File Operations
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save current file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Close current window" })
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Close all windows" })
keymap("n", "<leader>x", "<cmd>x<cr>", { desc = "Save and close current window" })
keymap("n", "<leader>X", "<cmd>xa<cr>", { desc = "Save and close all windows" })
keymap("n", "<leader>q!", "<cmd>q!<cr>", { desc = "Force close current window without saving" })
keymap("n", "<leader>Q!", "<cmd>qa!<cr>", { desc = "Force close all windows without saving" })
keymap("n", "<leader>c", "<cmd>bd<cr>", { desc = "Close current buffer" })

-- Buffer Navigation
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Switch to previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Switch to next buffer" })

-- Search and Replace
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Find and replace current word under cursor" })
keymap("n", "<leader>S", ":%s//g<Left><Left>", { desc = "Find and replace with last search pattern" })
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- File Explorer
keymap("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory in file explorer" })
keymap("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })

-- Terminal
local terminal = require("configs.terminal")
keymap("n", "<leader>tt", terminal.regular_term_toggle, { desc = "Toggle terminal" })
keymap("n", "<leader>tg", terminal.lazygit_toggle, { desc = "Toggle lazygit" })

-- Command Mode
keymap("n", ";", ":", { desc = "Enter command mode" })
keymap("n", ":", ":", { desc = "Enter command mode" })

-- Help and Documentation
keymap("n", "<leader>?", "<cmd>Cheatsheet<cr>", { desc = "Open cheatsheet for keybindings" })
keymap("n", "<leader>ch", "<cmd>Cheatsheet<cr>", { desc = "Open cheatsheet for keybindings" })

-- Configuration
local function ReloadLazyConfig()
    for name, _ in pairs(package.loaded) do
        if name:match("^plugins") then
            package.loaded[name] = nil
        end
    end
    dofile(vim.fn.stdpath("config") .. "/init.lua")
    vim.cmd("Lazy sync")
end
keymap("n", "<leader>rl", ReloadLazyConfig, { desc = "Reload Neovim configuration and sync plugins" })

-- Window Navigation keymaps moved to vim-navigator.lua plugin config 