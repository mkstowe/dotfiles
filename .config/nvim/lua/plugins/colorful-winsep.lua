return {
  "nvim-zh/colorful-winsep.nvim",
  event = "VeryLazy",
  config = function()
    require("colorful-winsep").setup()
  end,
}
