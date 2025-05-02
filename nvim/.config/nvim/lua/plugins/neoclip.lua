return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("neoclip").setup({
      history = 1000,
      enable_persistent_history = true,
      preview = true,
    })

    local keymap = vim.keymap.set
    -- Open Neoclip history via Telescope
    keymap("n", "<leader>yh", "<cmd>Telescope neoclip<CR>", { desc = "Telescope: Neoclip History" })
  end,
} 