return {
  "folke/zen-mode.nvim",
  event = "VeryLazy",
  config = function()
    require("zen-mode").setup {
      window = {
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
        },
      },
      plugins = {
        kitty = {
          enabled = true,
        },
      },
    }
  end,
}

