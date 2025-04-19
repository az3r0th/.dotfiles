return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.alejandra,
      },
      on_attach = function(client, bufnr)
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_buf_set_option(
            bufnr,
            "formatexpr",
            "v:lua.vim.lsp.formatexpr()"
          )
          vim.cmd([[
                      augroup FormatOnSave
                          autocmd! * <buffer>
                            autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })
                      augroup END
                  ]])
        end
      end,
    })
  end,
}
