vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.nix",
  callback = function()
    vim.fn.jobstart("home-manager switch", { detach = true })
    vim.notify("✅ home-manager updated!", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand("%:p:h")
    if vim.fn.isdirectory(dir) == 1 then
      vim.cmd("lcd " .. vim.fn.fnameescape(dir))
    end
  end,
})

