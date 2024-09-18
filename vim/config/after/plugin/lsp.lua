require("mason").setup()
require("mason-lspconfig").setup()

require'lspconfig'.scheme_langserver.setup{
	cmd = { "scheme-langserver.sps" },
	filetypes = { "scheme", "scm", "sls" },
}


