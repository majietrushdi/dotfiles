local opt = vim.opt

opt.relativenumber = true
vim.o.wrap = false

-- opt.shiftwidth = 4
-- opt.tabstop = 4

vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
  end,
})
