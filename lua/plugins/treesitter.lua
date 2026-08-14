return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter').install({
      'go', 'java', 'kotlin', 'lua', 'javascript', 'typescript',
      'python', 'json', 'yaml', 'html', 'css', 'vim', 'vimdoc', 'query',
    })

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'go', 'java', 'kotlin', 'lua', 'javascript', 'typescript', 'python', 'json', 'yaml', 'html', 'css' },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}

