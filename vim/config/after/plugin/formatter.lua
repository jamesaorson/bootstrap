local common = require('bootstrap.common')

common.run('formatting - keymaps', function()
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
end)

