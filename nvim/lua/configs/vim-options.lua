-- Line ending setting
local opt = vim.opt
opt.fileformat = "unix"
opt.fillchars = { eob = " " }
-- Tab and indentation settings
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- General useful settings
opt.number = true
opt.relativenumber = false
opt.smartindent = true
opt.wrap = false
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.undofile = true

-- Leader Key Mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set('n', ';', ':', { desc = "Command Key" })


--For Better life
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Find & Replace Current word" })
function ReloadLazyConfig()
  for name, _ in pairs(package.loaded) do
    if name:match("^plugins") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.fn.stdpath("config") .. "/init.lua")
  vim.cmd("Lazy sync")
end

-- Force zsh filetype aliased as sh 
vim.filetype.add {
	extension = {
		zsh = "sh",
		sh = "sh", -- force sh-files with zsh-shebang to still get sh as filetype
	},
	filename = {
		[".zshrc"] = "sh",
		[".zshenv"] = "sh",
	},
}

vim.keymap.set("n", "<leader>rl", ReloadLazyConfig, { desc = "Reload Lazy Config" })
