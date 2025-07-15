local common = require("bootstrap.common")

common.run("lazy", function()
		local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
		if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
			})
		end
		vim.opt.rtp:prepend(lazypath)
		require("lazy").setup({
			-- Color scheme
			{
			"catppuccin/nvim",
			lazy = false,
			name = "catppuccin",
			priority = 1000,
			},
			-- Fuzzy finder
			{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.4",
			dependencies = { "nvim-lua/plenary.nvim" },
			},
			-- Syntax highlighter/inspector
			{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			},
			-- File marking utility
			{
				"theprimeagen/harpoon",
			},
			-- Git client
			{
				"tpope/vim-fugitive",
			},
			-- Autocompletion
			{
				"hrsh7th/nvim-cmp",
				dependencies = {
				}
			},
			-- Formatter
			{ "mhartington/formatter.nvim" },
			-- Task tracking
			{
				"folke/todo-comments.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				opts = {},
			},
			-- Tabs on top of window
			{
				"romgrk/barbar.nvim",
				dependencies = {
					"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
						"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
				},
				init = function()
					vim.g.barbar_auto_setup = false
					end,
				opts = {
					-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
						-- animation = true,
					-- insert_at_start = true,
					-- …etc.
				},
				version = "^1.0.0", -- optional: only update when a new 1.x version is released
			},
			-- Floating terminal
			{
				"voldikss/vim-floaterm",
			},
			-- Tmux navigator
			{
				"christoomey/vim-tmux-navigator",
				lazy = false,
			},
			-- Trouble
			{
				"folke/trouble.nvim",
				dependencies = { "nvim-tree/nvim-web-devicons" },
				opts = {
					-- your configuration comes here
						-- or leave it empty to use the default settings
						-- refer to the configuration section below
				},
			},
			-- Which key
			{
				"folke/which-key.nvim",
				event = "VeryLazy",
				init = function()
					vim.o.timeout = true
					vim.o.timeoutlen = 300
					end,
				opts = {
					-- your configuration comes here
						-- or leave it empty to use the default settings
						-- refer to the configuration section below
				},
			},
			{'hrsh7th/nvim-cmp'},
			-- Mason
			{"williamboman/mason.nvim"},
		})
end)
