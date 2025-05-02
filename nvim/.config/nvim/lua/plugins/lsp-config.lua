return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          "rust_analyzer",
          "pyright",
          "gopls",
        },
        automatic_installation = true,
        handlers = {
          function(server_name) -- default handler (optional)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = {"vim"},
                  },
                },
              },
            })
          end,
          ["gopls"] = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            lspconfig.gopls.setup({
              capabilities = capabilities,
              settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                    shadow = true,
                    nilness = true,
                    unusedwrite = true,
                    useany = true,
                    unusedvariable = true,
                  },
                  staticcheck = true,
                  gofumpt = true,
                  codelenses = {
                    generate = true,
                    gc_details = true,
                    test = true,
                    tidy = true,
                  },
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local keymap = vim.keymap.set
      local on_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        -- LSP specific keymaps
        keymap("n", "gd", vim.lsp.buf.definition, bufopts)
        keymap("n", "gD", vim.lsp.buf.declaration, bufopts)
        keymap("n", "gr", vim.lsp.buf.references, bufopts)
        keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
        keymap("n", "K", vim.lsp.buf.hover, bufopts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        keymap("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        keymap("n", "<leader>ds", vim.lsp.buf.document_symbol, bufopts)
        keymap("n", "<leader>ws", vim.lsp.buf.workspace_symbol, bufopts)
        keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        keymap("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        keymap("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, bufopts)
        keymap("n", "<leader>di", vim.diagnostic.open_float, bufopts)
        keymap("n", "[d", vim.diagnostic.goto_prev, bufopts)
        keymap("n", "]d", vim.diagnostic.goto_next, bufopts)
        keymap("n", "<leader>dl", vim.diagnostic.setloclist, bufopts)
      end

      -- Apply on_attach to all LSP clients
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local default_config = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Apply default config to all LSP servers
      for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
        lspconfig[server].setup(default_config)
      end
    end,
  },
}
