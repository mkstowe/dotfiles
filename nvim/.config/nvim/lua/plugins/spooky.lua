return {
  "ggandor/leap-spooky.nvim",
  lazy = false,
  config = function()
    require("leap-spooky").setup {
      paste_on_remote_yank = true,
    }
  end,
}
