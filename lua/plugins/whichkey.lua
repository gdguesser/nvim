-- ~/.config/nvim/lua/plugins/whichkey.lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")

      -- Modern setup
      wk.setup({
        presets = {
          operators = true, -- Enable operator presets like gc for comments
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
        icons = {
          breadcrumb = "»", -- symbol for breadcrumbs
          separator = "➜",  -- symbol for separator
          group = "+",      -- symbol for groups
        },
        show_help = false,   -- hide help popup
        ignore_missing = true, -- don’t warn about missing desc
        triggers_blacklist = {
          -- silence warnings about overlapping mappings like gc/gcc
          n = { "gc" },
          v = { "gc" },
        },
      })

      -- Register key groups (modern spec)
      wk.register({
        { "<leader>f", group = "file / format" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>t", group = "tests" },
        { "<leader>r", group = "run / refactor" },
      })

      -- Optional: add some default key bindings here if desired
      -- Example: <leader>ff to find files with Telescope
      -- This is safe to extend as your setup grows
    end,
  },
}

