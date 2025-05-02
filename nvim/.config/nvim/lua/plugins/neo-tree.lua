return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local neo_tree = require("neo-tree")
      local keymap = vim.keymap.set
      neo_tree.setup({
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
            show_hidden = true,
          },
        },
      })

      -- Neo-tree specific keymaps
      keymap('n', '<M-n>', ':Neotree toggle<CR>', { noremap = true, silent = true, desc = "Toggle Neo-tree" })
      keymap('n', '<leader>th', function()
          neo_tree.setup({
            filesystem = {
              filtered_items = {
                show_hidden = not neo_tree.config.filesystem.filtered_items.show_hidden,
              },
            },
          })
        end,
        { desc = "Toggle hidden files in Neo-tree" })
    end
  }
}
