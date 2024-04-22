return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependendcies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("hardtime").setup {
      disabled_keys = {
        ["<Up>"] = {},
        ["<Down>"] = {},
        ["<Left>"] = {},
        ["<Right>"] = {},
      },
      disable_mouse = false,
    }
  end,
}
