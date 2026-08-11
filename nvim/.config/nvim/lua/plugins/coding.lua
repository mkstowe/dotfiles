return {
  {
    "stevearc/conform.nvim",
    opts = require "config.plugins.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "config.plugins.lsp"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    opts = require "config.plugins.treesitter",
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html" },
    opts = {},
  },
  {
    "danymat/neogen",
    ft = {
      "typescript",
      "lua",
      "javascript",
      "c",
      "sh",
      "cs",
      "cpp",
      "go",
      "java",
      "php",
      "kotlin",
      "python",
      "ruby",
      "rust",
      "vue",
    },
    opts = {},
  },
  {
    "monaqa/dial.nvim",
    lazy = false,
    opts = require "config.plugins.dial",
    config = function(_, opts)
      require("dial.config").augends:register_group(opts.groups)
    end,
  },
}
