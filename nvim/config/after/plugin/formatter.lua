local common = require('bootstrap.common')
local null_ls = require("null-ls")

common.run('formatting - null-ls', function()
    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.prettier,
        },
    })
end)

common.run('formatting - keymaps', function()
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
end)
