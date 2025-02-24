vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.nix",
  callback = function()
    vim.fn.jobstart("home-manager switch", { detach = true })
    vim.notify("✅ home-manager updated!", vim.log.levels.INFO)
  end,
})

