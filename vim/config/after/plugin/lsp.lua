require("mason").setup()
require("mason-lspconfig").setup()

require'lspconfig'.scheme_langserver.setup{
	filetypes = { "scheme", "scm", "sls" },
}


