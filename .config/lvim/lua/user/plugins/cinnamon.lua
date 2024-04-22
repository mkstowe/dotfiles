return {
  'declancm/cinnamon.nvim',
  config = function()
    require('cinnamon').setup {
      extra_keymaps = true,
      extended_keymaps = true,
      hide_cursor = true,
      scroll_limit = 25,
    }
  end
}
