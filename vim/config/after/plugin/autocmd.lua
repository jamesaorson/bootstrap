vim.api.nvim_create_autocmd("BufRead", {
  pattern = {"*.sld", "*.sls","*.sps","*.scm"},
  command = "setfiletype scheme",
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = {"*.sld", "*.sls","*.sps","*.scm"},
  command = "setfiletype scheme",
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'scheme',
  callback = function(args)
    vim.lsp.start({
      name = 'scheme-langserver',
      cmd = {
		'{path-to-run}',
        '~/scheme-langserver.log',
        --enable multi-thread
        'enable',
        --disable type inference, because it's on very early stage.
        'diable',
      },
      root_dir = vim.fs.root(args.buf, {'.gitignore','AKKU.manifest'}),
    })
  end
})

