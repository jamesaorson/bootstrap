vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = 'https://github.com/NvChad/showkeys', opt = true },
})

require "mason".setup()
require "showkeys".setup({ position = "top-right" })
require "mini.pick".setup()
require "oil".setup()

vim.lsp.enable({
	"bashls",
	"ccls",
	-- "cmake",
	"cssls",
	"dockerls",
	-- "gh_actions_ls",
	-- "gitlab_ci_ls",
	"gopls",
	-- "guile_ls",
	-- "helm_ls",
	-- "html",
	-- "htmx",
	"jsonls",
	"lua_ls",
	-- "markdown_oxide",
	-- "pylsp",
	-- "tailwindcss",
	-- "ts_ls",
	-- "vue_ls",
	"yamlls",
})

-- colors
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- keymaps
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
