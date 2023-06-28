local common = require("bootstrap.common")

common.run("copilot", function()
	require("copilot").setup({
		suggestion = { enabled = false },
		panel = { enabled = false },
	})
end)
