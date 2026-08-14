return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- Install parsers
    require('nvim-treesitter').install({ 'go', 'lua', 'vim', 'vimdoc', 'query' })
    
    -- Enable highlighting for Go files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'go', 'lua' },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}

