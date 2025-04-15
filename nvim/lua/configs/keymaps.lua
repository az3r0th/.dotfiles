local keymap = vim.keymap.set

-- File operations
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all windows" })
keymap("n", "<leader>x", "<cmd>x<cr>", { desc = "Save and quit" })
keymap("n", "<leader>X", "<cmd>xa<cr>", { desc = "Save and quit all windows" })
keymap("n", "<leader>q!", "<cmd>q!<cr>", { desc = "Force quit without saving" })
keymap("n", "<leader>Q!", "<cmd>qa!<cr>", { desc = "Force quit all windows without saving" })

-- Buffer navigation
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>c", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Command mode
keymap("n", ";", ":", { desc = "Enter command mode" })
keymap("n", ":", ";", { desc = "Enter command mode" })

-- Search and replace
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Find & Replace Current word" })
keymap("n", "<leader>S", ":%s//g<Left><Left>", { desc = "Find & Replace" })

-- Clear search highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Oil.nvim
keymap("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
keymap("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })

-- Cheatsheet
keymap("n", "<leader>?", "<cmd>Cheatsheet<cr>", { desc = "Open Cheatsheet" })
keymap("n", "<leader>ch", "<cmd>Cheatsheet<cr>", { desc = "Open Cheatsheet" })

-- Lazy config reload
local function ReloadLazyConfig()
  for name, _ in pairs(package.loaded) do
    if name:match("^plugins") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.fn.stdpath("config") .. "/init.lua")
  vim.cmd("Lazy sync")
end

keymap("n", "<leader>rl", ReloadLazyConfig, { desc = "Reload Lazy Config" }) 