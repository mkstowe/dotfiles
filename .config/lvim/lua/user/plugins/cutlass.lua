return {
  'gbprod/cutlass.nvim',
  config = function()
    require('cutlass').setup {
      cut_key = 'x',
      override_del = true
    }
  end
}
