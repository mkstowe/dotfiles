return {
  { "dstein64/nvim-scrollview", opts = {} },
  { "folke/twilight.nvim", event = "VeryLazy" },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
        },
      },
      plugins = { kitty = { enabled = true } },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
  },
}
