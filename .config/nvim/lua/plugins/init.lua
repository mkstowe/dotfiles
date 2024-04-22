return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "angular-language-server",
        "eslint-lsp",
        "jq",
        "json-lsp",
        "shellcheck",
        "typescript-language-server",
        "yaml-language-server",
        "prettier",
        "pyright",
        "quick-lint-js",
        "sqls",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      eensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "angular",
        "bash",
        "javascript",
        "typescript",
        "json",
        "python",
        "scss",
        "sql",
        "xml",
        "yaml",
      },
    },
  },
}
