return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "bashls", "rust_analyzer", "pyright" },
        automatic_installation = true,
        handlers = {
          function(server_name) -- default handler (optional)
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require("lspconfig")[server_name].setup {
              capabilities = capabilities
            }
          end,
          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim", } --"it", "describe", "before_each", "after_each" },
                  }
                }
              }
            }
          end,
        }
      }
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
      local on_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }

        -- Keybindings
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
      end
      lspconfig.lua_ls.setup {
        on_attach = on_attach,
      }
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require 'lspconfig'.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          } } }
    end
  },
}
