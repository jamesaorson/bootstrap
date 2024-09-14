local common = require("bootstrap.common")

--- This function is taken from https://github.com/norcalli/nvim_utils
common.run("autocmds", function()
	local api = vim.api
	local autocmds = {
		terminal_start = {
			{ "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
			{ "TermOpen", "*", "startinsert" },
			{ "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
		},
		save_all_on_close = {
			{ "VimLeavePre", "*", "wa!" },
		},
	}
	for group_name, definition in pairs(autocmds) do
		api.nvim_command("augroup " .. group_name)
		api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			api.nvim_command(command)
		end
		api.nvim_command("augroup END")
	end
end)

