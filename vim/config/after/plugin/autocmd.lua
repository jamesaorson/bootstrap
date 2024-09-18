vim.api.nvim_create_autocmd("BufRead", {
  pattern = {"*.sld", "*.sls","*.sps","*.scm"},
  command = "setfiletype scheme",
})

vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = {"*.sld", "*.sls","*.sps","*.scm"},
  command = "setfiletype scheme",
})

