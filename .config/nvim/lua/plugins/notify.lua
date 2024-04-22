return {
  "rcarriga/nvim-notify",
  lazy = false,
  config = function()
    require("notify").setup {
      timeout = 1000,
    }
  end,
}
