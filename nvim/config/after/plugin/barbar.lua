local common = require("bootstrap.common")

common.run("barbar", function()
	local map = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }

	-- Move to previous/next
	map("n", "<leader>,", "<Cmd>BufferPrevious<CR>", opts)
	map("n", "<leader>.", "<Cmd>BufferNext<CR>", opts)
	-- Re-order to previous/next
	map("n", "<leader><", "<Cmd>BufferMovePrevious<CR>", opts)
	map("n", "<leader>>", "<Cmd>BufferMoveNext<CR>", opts)
	-- Goto buffer in position...
	map("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", opts)
	map("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", opts)
	map("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", opts)
	map("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", opts)
	map("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", opts)
	map("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", opts)
	map("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", opts)
	map("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", opts)
	map("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", opts)
	map("n", "<leader>0", "<Cmd>BufferLast<CR>", opts)
end)

