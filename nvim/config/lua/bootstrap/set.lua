local common = require("bootstrap.common")

common.run("cursor and columns", function()
	vim.opt.guicursor = ""
	vim.opt.cursorline = true
	vim.opt.cursorcolumn = true
	vim.opt.colorcolumn = "81"
	vim.opt.cursorline = true
end)

common.run("gutter", function()
	vim.opt.number = true
	vim.opt.relativenumber = true
end)

common.run("history", function()
	vim.opt.swapfile = false
	vim.opt.backup = false
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
	vim.opt.undofile = true
end)

common.run("indent", function()
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.expandtab = true
	vim.opt.smartindent = true
	vim.opt.wrap = false
end)

common.run("netrw", function()
    vim.g.netrw_banner = false
end)

common.run("search", function()
	vim.opt.hlsearch = false
	vim.opt.incsearch = true
end)

common.run("other options", function()
	vim.opt.termguicolors = false
	vim.opt.signcolumn = "yes"
	vim.opt.updatetime = 50

	vim.g.mapleader = " "
    vim.g.netrw_liststyle = 3
end)

