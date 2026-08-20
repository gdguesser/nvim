return {
  {
    "williamboman/mason.nvim",
    config = true,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "ts_ls",
          "eslint",
          "jdtls",
          "lua_ls",
          "pyright",
          "groovyls",
        },
        -- jdtls must not be auto-enabled here; nvim-jdtls manages it exclusively
        automatic_enable = {
          exclude = { "jdtls" },
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end,
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
          },
        },
      })

      vim.lsp.config("ts_ls", {})
      vim.lsp.config("eslint", {})
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.config("pyright", {})
      vim.lsp.config("groovyls", {
        filetypes = { "groovy" },
        -- groovyls is blind to Spock/jOOQ without the Gradle classpath; resolve it once and cache
        on_new_config = function(config, root_dir)
          local cache_dir = vim.fn.stdpath("cache") .. "/groovyls"
          vim.fn.mkdir(cache_dir, "p")
          local cache_file = cache_dir .. "/" .. vim.fn.fnamemodify(root_dir, ":t") .. ".txt"
          local classpath = {}

          local f = io.open(cache_file, "r")
          if f then
            for line in f:lines() do table.insert(classpath, line) end
            f:close()
          end

          if #classpath == 0 then
            local gradle_bin = vim.fn.filereadable(root_dir .. "/gradlew") == 1
              and (root_dir .. "/gradlew") or "gradle"

            local init_script = vim.fn.tempname() .. ".gradle"
            local sf = io.open(init_script, "w")
            if sf then
              -- .resolve() works even before a full build; .resolvedArtifacts requires prior resolution
              sf:write([[
allprojects {
  tasks.register("_nvimGroovylsClasspath") {
    doLast {
      configurations.findByName("testRuntimeClasspath")?.resolve()?.each { println it }
      ["groovy/main","groovy/test","java/main","java/test"].each {
        def d = new File(projectDir, "build/classes/$it")
        if (d.exists()) println d.absolutePath
      }
    }
  }
}
]])
              sf:close()
              vim.notify("groovyls: resolving Gradle classpath (first open, please wait)...", vim.log.levels.INFO)
              local out = vim.fn.system({
                gradle_bin, "-p", root_dir, "-q", "--console=plain",
                "--init-script", init_script, "_nvimGroovylsClasspath",
              })
              vim.fn.delete(init_script)

              for line in out:gmatch("[^\r\n]+") do
                if line:match("%.jar$") or vim.fn.isdirectory(line) == 1 then
                  table.insert(classpath, line)
                end
              end

              if #classpath > 0 then
                local cf = io.open(cache_file, "w")
                if cf then cf:write(table.concat(classpath, "\n")); cf:close() end
              end
            end
          end

          if #classpath > 0 then
            config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
              groovy = { classpath = classpath },
            })
          end
        end,
      })

      vim.api.nvim_create_user_command("GroovylsRefreshClasspath", function()
        local cache_dir = vim.fn.stdpath("cache") .. "/groovyls"
        local cache_file = cache_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ".txt"
        vim.fn.delete(cache_file)
        vim.cmd("LspRestart groovyls")
        vim.notify("groovyls: classpath cache cleared, restarting...", vim.log.levels.INFO)
      end, { desc = "Re-resolve Gradle classpath for groovyls" })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          local jdtls = require("jdtls")
          local mason_registry = require("mason-registry")
          local jdtls_pkg = mason_registry.get_package("jdtls")
          local jdtls_path = jdtls_pkg:get_install_path()
          local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
          local config_dir = jdtls_path .. "/config_linux"
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
          local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

          local config = {
            cmd = {
              "java",
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-Xmx1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens", "java.base/java.util=ALL-UNNAMED",
              "--add-opens", "java.base/java.lang=ALL-UNNAMED",
              "-jar", launcher,
              "-configuration", config_dir,
              "-data", workspace_dir,
            },
            root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
            settings = {
              java = {
                signatureHelp = { enabled = true },
                completion = {
                  favoriteStaticMembers = {
                    "org.junit.Assert.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                  },
                },
                sources = {
                  organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                  },
                },
              },
            },
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          }

          jdtls.start_or_attach(config)
        end,
      })
    end,
  },
}

