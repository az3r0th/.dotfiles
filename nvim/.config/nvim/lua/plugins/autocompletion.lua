return {
  {
    "neovim/nvim-lspconfig"
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "j-hui/fidget.nvim",
    }
  },
  { "saadparwaiz1/cmp_luasnip" },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets"
    },
    build = "make install_jsregexp",
    config = function()
      local luasnip = require('luasnip')
      vim.keymap.set({ 'i', 's' }, '<Tab>', function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          return '<Tab>'
        end
      end, { expr = true })

      vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { expr = true })
      -- Load friendly-snippets
      require('luasnip.loaders.from_vscode').lazy_load()
    end

  }
}
