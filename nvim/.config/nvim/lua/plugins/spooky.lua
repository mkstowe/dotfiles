return {
  "ggandor/leap-spooky.nvim",
  config = function()
    require("leap-spooky").setup {
      paste_on_remote_yank = true,
    }
  end,
}
