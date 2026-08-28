-- 用户自定义插件配置

return {
  -- 添加更多 LSP 服务器
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript/JavaScript
        tsserver = {},
        -- JSON
        jsonls = {},
        -- CSS/SCSS
        cssls = {},
        -- HTML
        html = {},
        -- Markdown
        marksman = {},
        -- YAML
        yamlls = {},
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
        -- Rust
        rust_analyzer = {},
        -- Go
        gopls = {},
        -- Python
        pyright = {},
        -- C/C++
        clangd = {},
      },
    },
  },

  -- Copilot (AI 代码补全)
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          keymap = {
            accept = "<C-l>",
            accept_word = false,
            accept_line = false,
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<C-x>",
          },
        },
      })
    end,
  },

  -- 更多 Treesitter 解析器
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "python",
        "rust",
        "go",
        "typescript",
        "javascript",
        "tsx",
        "jsx",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "bash",
        "dockerfile",
      },
    },
  },

  -- 更好的 Telescope 预览
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git",
          "__pycache__",
          "target",
          "dist",
          ".venv",
          "venv",
        },
      },
    },
  },

  -- ============ Text Editing 模块 ============

  -- mini.nvim 系列 (包含所有 mini 模块)
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      -- mini.comment - 注释
      require("mini.comment").setup()

      -- mini.ai - 增强文本对象
      require("mini.ai").setup()

      -- mini.pairs - 自动配对
      require("mini.pairs").setup()

      -- mini.surround - 环绕编辑
      require("mini.surround").setup()

      -- mini.jump2d - 快速跳转
      require("mini.jump2d").setup()

      -- mini.bracketed - 括号导航
      require("mini.bracketed").setup()
    end,
  },

  -- 缩进指示器
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- 多光标编辑
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    config = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
      }
    end,
  },

  -- 更好的搜索
  {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    config = function()
      require("hlslens").setup()
    end,
  },

  -- 文本交换
  {
    "tommcdo/vim-exchange",
    event = "VeryLazy",
  },

  -- 移动增强 (使用 LazyVim 默认的 flash.nvim)
}
