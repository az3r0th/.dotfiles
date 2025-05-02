return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local keymap = vim.keymap.set

    -- Keymaps
    keymap("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open Diffview" })
    keymap("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
    keymap("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "File History" })
    keymap("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current File History" })

    require("diffview").setup({
      enhanced_diff_hl = true,
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "always",
        },
      },
    })
  end,
}
