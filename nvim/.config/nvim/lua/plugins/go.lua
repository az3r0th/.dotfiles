return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "mfussenegger/nvim-dap",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        goimports = "gopls", -- if set to 'gopls' will use golsp format
        gofmt = "golines",  -- if set to gopls will use golsp format
        max_line_len = 120,
        tag_transform = false,
        test_dir = "",
        comment_placeholder = "",
        lsp_cfg = true,       -- false: use your own lspconfig
        lsp_gofumpt = true,   -- true: set default gofmt in gopls format to gofumpt
        lsp_on_attach = true, -- use on_attach from go.nvim
        dap_debug = true,
        dap_debug_gui = true,
        dap_debug_vt = true,
      })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimport()
        end,
        group = vim.api.nvim_create_augroup("GoFormat", {}),
      })

      -- Go specific keymaps
      local keymap = vim.keymap.set
      keymap("n", "<leader>gt", "<cmd>GoTest<cr>", { desc = "Run Go test" })
      keymap(
        "n",
        "<leader>gT",
        "<cmd>GoTestFunc<cr>",
        { desc = "Run Go test for current function" }
      )
      keymap("n", "<leader>gr", "<cmd>GoRun<cr>", { desc = "Run Go program" })
      keymap("n", "<leader>gi", "<cmd>GoImport<cr>", { desc = "Add Go import" })
      keymap(
        "n",
        "<leader>gd",
        "<cmd>GoDoc<cr>",
        { desc = "Show Go documentation" }
      )
      keymap("n", "<leader>gl", "<cmd>GoLint<cr>", { desc = "Run Go linter" })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
    ft = "go",
  },
}
