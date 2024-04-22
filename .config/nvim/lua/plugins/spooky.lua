-- return {
--   "ggandor/spooky.nvim",
--   lazy = false,
--   config = function()
--     require("spooky").setup {
--       paste_on_remote_yank = true,
--     }
--   end,
-- }

return {
  "ggandor/leap-spooky.nvim",
  lazy = false,
  config = function()
    require("leap-spooky").setup {
      paste_on_remote_yank = true,
    }
  end,
}
