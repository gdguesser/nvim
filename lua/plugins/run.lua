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

      local function run_file()
        local file = vim.fn.expand("%")
        local ft = vim.bo.filetype
        local cmd

        if ft == "go" then
          cmd = "go run " .. file
        elseif ft == "java" then
          local classname = vim.fn.expand("%:t:r")
          cmd = "javac " .. file .. " && java " .. classname
        elseif ft == "python" then
          cmd = "python3 " .. file
        elseif ft == "javascript" then
          cmd = "node " .. file
        elseif ft == "typescript" then
          cmd = "npx tsx " .. file
        elseif ft == "kotlin" then
          local out = vim.fn.expand("%:t:r")
          cmd = "kotlinc " .. file .. " -include-runtime -d " .. out .. ".jar && java -jar " .. out .. ".jar"
        else
          vim.notify("No run command for filetype: " .. ft, vim.log.levels.WARN)
          return
        end

        require("toggleterm").exec(cmd)
      end

      local function run_project()
        local ft = vim.bo.filetype
        local cmd

        if ft == "go" then
          cmd = "go run ."
        elseif ft == "java" then
          if vim.fn.filereadable("pom.xml") == 1 then
            cmd = "mvn compile exec:java"
          elseif vim.fn.filereadable("gradlew") == 1 then
            cmd = "./gradlew run"
          else
            cmd = "javac *.java && java Main"
          end
        elseif ft == "python" then
          cmd = "python3 main.py"
        elseif ft == "javascript" or ft == "typescript" then
          cmd = "npm start"
        else
          vim.notify("No project run command for filetype: " .. ft, vim.log.levels.WARN)
          return
        end

        require("toggleterm").exec(cmd)
      end

      local function run_tests()
        local ft = vim.bo.filetype
        local cmd

        if ft == "go" then
          cmd = "go test -v ./..."
        elseif ft == "java" then
          if vim.fn.filereadable("pom.xml") == 1 then
            cmd = "mvn test"
          elseif vim.fn.filereadable("gradlew") == 1 then
            cmd = "./gradlew test"
          else
            cmd = "java -jar junit-platform-console-standalone.jar --scan-classpath"
          end
        elseif ft == "python" then
          cmd = "python3 -m pytest -v"
        elseif ft == "javascript" or ft == "typescript" then
          cmd = "npm test"
        else
          vim.notify("No test command for filetype: " .. ft, vim.log.levels.WARN)
          return
        end

        require("toggleterm").exec(cmd)
      end

      vim.keymap.set("n", "<leader>rr", run_file, { desc = "Run current file" })
      vim.keymap.set("n", "<leader>rp", run_project, { desc = "Run project" })
      vim.keymap.set("n", "<leader>rt", run_tests, { desc = "Run tests" })
      vim.keymap.set("n", "<leader>rb", function()
        local ft = vim.bo.filetype
        if ft == "go" then
          require("toggleterm").exec("go build .")
        elseif ft == "java" and vim.fn.filereadable("pom.xml") == 1 then
          require("toggleterm").exec("mvn package -DskipTests")
        elseif ft == "java" and vim.fn.filereadable("gradlew") == 1 then
          require("toggleterm").exec("./gradlew build")
        end
      end, { desc = "Build project" })
    end,
  },
}
