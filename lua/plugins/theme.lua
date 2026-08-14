return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          cmp = true,
          treesitter = true,
          telescope = { enabled = true },
          mason = true,
          which_key = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              warnings = { "undercurl" },
            },
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

