return {
  "sudormrfbin/cheatsheet.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("cheatsheet").setup({
      bundled_cheatsheets = {
        enabled = { "default", "lua", "markdown", "regex", "netrw", "unicode" },
        disabled = { "nerd-fonts" },
      },
      bundled_plugin_cheatsheets = {
        enabled = {
          "telescope.nvim",
          "nvim-cmp",
          "neo-tree.nvim",
          "which-key.nvim",
          "toggleterm.nvim",
          "vim-tmux-navigator",
          "oil.nvim",
          "lualine.nvim",
          "harpoon",
        },
        disabled = {},
      },
      include_only_installed_plugins = true,
    })
  end,
} 