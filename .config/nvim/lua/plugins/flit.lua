return {
  "ggandor/flit.nvim",
  lazy = false,
  config = function()
    require("flit").setup {
      labeled_modes = "nx",
    }
  end,
}
