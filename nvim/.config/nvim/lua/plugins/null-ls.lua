return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting

    local sources = {}

    local function add_formatter(builtin_name, binary)
      local builtin = formatting[builtin_name]
      if not builtin then
        return
      end
      if binary and vim.fn.executable(binary) ~= 1 then
        return
      end
      table.insert(sources, builtin)
    end

    add_formatter("stylua", "stylua")
    add_formatter("black", "black")
    add_formatter("shfmt", "shfmt")
    add_formatter("alejandra", "alejandra")

    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if not client.server_capabilities.documentFormattingProvider then
          return
        end

        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

        local group = vim.api.nvim_create_augroup("FormatOnSave", { clear = false })
        vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = group,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              async = false,
              bufnr = bufnr,
              filter = function(fmt_client)
                return fmt_client.name == "null-ls"
              end,
            })
          end,
        })
      end,
    })
  end,
}
