local function lsp_on_attach(bufnr)
  local keymap = vim.keymap.set
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

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

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = { "bashls", "rust_analyzer", "pyright", "lua_ls", "gopls" }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      for _, server_name in ipairs({ "bashls", "rust_analyzer", "pyright" }) do
        vim.lsp.config(server_name, {
          capabilities = capabilities,
        })
      end

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      vim.lsp.config("gopls", {
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

      local lsp_group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_group,
        callback = function(args)
          lsp_on_attach(args.buf)
        end,
      })

      vim.lsp.enable(servers)
    end,
  },
}
