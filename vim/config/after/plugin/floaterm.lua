local common = require("bootstrap.common")

common.run("floaterm", function()
	local map = vim.api.nvim_set_keymap
	local opts = { noremap = true, silent = true }

	map("n", "<leader>tn", "<Cmd>FloatermNew<CR>", opts)
	map("n", "<leader>th", "<Cmd>FloatermHide<CR>", opts)
	map("n", "<leader>ts", "<Cmd>FloatermShow<CR>", opts)
end)

