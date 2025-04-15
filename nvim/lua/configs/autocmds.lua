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

-- Auto-reload Neovim config on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.lua", "init.lua" },
  callback = function()
    local config_path = vim.fn.stdpath("config")
    local current_file = vim.fn.expand("%:p")
    
    -- Check if the file is in the config directory
    if string.find(current_file, config_path, 1, true) then
      -- Clear the command line
      vim.cmd("echo ''")
      -- Reload the config
      vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
      vim.notify("✅ Neovim config reloaded!", vim.log.levels.INFO)
    end
  end,
})

