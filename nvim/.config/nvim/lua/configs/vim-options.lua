local opt = vim.opt
local g = vim.g

-- Line ending and encoding
opt.fileformat = "unix"
opt.fileencoding = "utf-8"
opt.fillchars = { eob = " " }

-- Tab and indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Line numbers and cursor
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.signcolumn = "yes"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Performance
opt.lazyredraw = true
opt.updatetime = 300
opt.timeoutlen = 300

-- UI
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true

-- Backup and undo
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Leader Key settings
g.mapleader = " "
g.maplocalleader = "\\"

-- Filetype settings
vim.filetype.add {
	extension = {
		zsh = "sh",
		sh = "sh",
	},
	filename = {
		[".zshrc"] = "sh",
		[".zshenv"] = "sh",
	},
}
