return {
  'catppuccin/nvim',
  config = function()
    require("catppuccin").setup {
      flavour = "mocha"
    }
  end
}
