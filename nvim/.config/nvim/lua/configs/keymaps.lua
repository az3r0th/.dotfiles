-- Leader key shortcuts description:
-- <leader>w  - Save file
-- <leader>q  - Quit window
-- <leader>Q  - Quit all windows
-- <leader>x  - Save and quit
-- <leader>X  - Save and quit all windows
-- <leader>q! - Force quit without saving
-- <leader>Q! - Force quit all windows without saving
-- <leader>c  - Close buffer
-- <leader>s  - Find & Replace Current word
-- <leader>S  - Find & Replace
-- <leader>h  - Clear search highlights
-- <leader>e  - Open file explorer
-- <leader>?  - Open Cheatsheet
-- <leader>ch - Open Cheatsheet
-- <leader>rl - Reload Lazy Config
-- <leader>tt - Toggle terminal
-- <leader>tg - Toggle lazygit

-- Go specific shortcuts:
-- <leader>gt - Run Go test
-- <leader>gT - Run Go test for current function
-- <leader>gr - Run Go program
-- <leader>gi - Add Go import
-- <leader>gd - Show Go documentation
-- <leader>gl - Run Go linter

-- LSP shortcuts:
-- <leader>rn - Rename symbol
-- gd         - Go to definition
-- gr         - Find references
-- K          - Show hover documentation

local keymap = vim.keymap.set

-- File operations: Save, quit, and buffer management
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save current file" })
keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Save current file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Close current window" })
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Close all windows" })
keymap("n", "<leader>x", "<cmd>x<cr>", { desc = "Save and close current window" })
keymap("n", "<leader>X", "<cmd>xa<cr>", { desc = "Save and close all windows" })
keymap("n", "<leader>q!", "<cmd>q!<cr>", { desc = "Force close current window without saving" })
keymap("n", "<leader>Q!", "<cmd>qa!<cr>", { desc = "Force close all windows without saving" })

-- Buffer navigation: Switch between open buffers
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Switch to previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Switch to next buffer" })
keymap("n", "<leader>c", "<cmd>bd<cr>", { desc = "Close current buffer" })

-- Command mode: Quick access to command line
keymap("n", ";", ":", { desc = "Enter command mode" })
keymap("n", ":", ":", { desc = "Enter command mode" })

-- Search and replace: Find and modify text
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Find and replace current word under cursor" })
keymap("n", "<leader>S", ":%s//g<Left><Left>", { desc = "Find and replace with last search pattern" })

-- Search: Clear highlights and navigation
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- File explorer: Quick access to file system
keymap("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory in file explorer" })
keymap("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })

-- Help and documentation: Access cheatsheet and help
keymap("n", "<leader>?", "<cmd>Cheatsheet<cr>", { desc = "Open cheatsheet for keybindings" })
keymap("n", "<leader>ch", "<cmd>Cheatsheet<cr>", { desc = "Open cheatsheet for keybindings" })

-- Configuration: Reload and update settings
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

-- Terminal: Toggle terminal and lazygit
local terminal = require("configs.terminal")
keymap("n", "<leader>tt", terminal.regular_term_toggle, { desc = "Toggle terminal" })
keymap("n", "<leader>tg", terminal.lazygit_toggle, { desc = "Toggle lazygit" }) 