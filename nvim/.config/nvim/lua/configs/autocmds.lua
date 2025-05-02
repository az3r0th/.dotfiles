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

