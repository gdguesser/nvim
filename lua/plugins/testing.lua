return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "nvim-neotest/nvim-nio", -- 🔴 REQUIRED
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
          }),
        },
      })

      vim.keymap.set("n", "<leader>tn", function()
        neotest.run.run()
      end, { desc = "Run nearest test" })

      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run file tests" })

      vim.keymap.set("n", "<leader>tp", function()
        neotest.run.run("./")
      end, { desc = "Run package tests" })

      vim.keymap.set("n", "<leader>to", neotest.output.open, { desc = "Test output" })
      vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "Test summary" })
      
      vim.keymap.set("n", "<leader>tl", function()
        neotest.run.run_last()
      end, { desc = "Run last test" })
      
      vim.keymap.set("n", "<leader>td", function()
        neotest.run.run({ strategy = "dap" })
      end, { desc = "Debug nearest test" })
    end,
  },
}

