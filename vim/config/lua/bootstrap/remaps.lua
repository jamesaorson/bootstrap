local common = require("bootstrap.common")

common.run("remaps", function()
    vim.keymap.set("n", "<leader>d", vim.cmd.Ex)
	vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
	vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
	vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
	vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")
end)

