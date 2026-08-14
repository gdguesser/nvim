return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",
        size = 15,
        open_mapping = [[<C-\>]],
      })

      -- Run current Go file
      vim.keymap.set("n", "<leader>rr", function()
        local file = vim.fn.expand("%")
        require("toggleterm").exec("go run " .. file)
      end, { desc = "Run current go file" })

      -- Run Go project (go run .)
      vim.keymap.set("n", "<leader>rp", function()
        require("toggleterm").exec("go run .")
      end, { desc = "Run go project" })

      -- Build Go project
      vim.keymap.set("n", "<leader>rb", function()
        require("toggleterm").exec("go build .")
      end, { desc = "Build go project" })

      -- Run tests in current file (fallback)
      vim.keymap.set("n", "<leader>rt", function()
        local file = vim.fn.expand("%:t:r") -- get filename without extension
        require("toggleterm").exec("go test -v -run " .. file)
      end, { desc = "Run go tests in current file" })

      -- Run all tests in package
      vim.keymap.set("n", "<leader>ra", function()
        require("toggleterm").exec("go test -v ./...")
      end, { desc = "Run all go tests" })
    end,
  },
}

