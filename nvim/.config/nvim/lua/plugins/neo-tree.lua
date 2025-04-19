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
      vim.keymap.set('n', '<M-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>th', function()
          neo_tree.setup({
            filesystem = {
              filtered_items = {
                show_hidden = not require("neo-tree").config.filesystem.filtered_items.show_hidden,
              },
            },
          })
        end,
        { desc = "Toggle hidden files in Neo-tree" })
    end
  }
}
