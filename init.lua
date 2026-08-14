vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { silent = true, desc = "Delete buffer" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded" },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go", "*.java" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

require("lazy").setup("plugins")

