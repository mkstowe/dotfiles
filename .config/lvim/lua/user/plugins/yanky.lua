return {
  'gbprod/yanky.nvim',
  config = function()
    require("yanky").setup {
      system_clipboard = {
        sync_with_ring = true,
      }
    }
  end,
}
