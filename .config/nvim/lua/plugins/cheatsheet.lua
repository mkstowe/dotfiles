return {
  "sudormrfbin/cheatsheet.nvim",
  lazy = false,
  requires = {
    { "nvim-telescope/telescope.nvim" },
    { "nvim-lua/popup.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("cheatsheet").setup {
      bundled_cheatsheets = false,
      bundled_plugin_cheatsheets = false,
      include_only_installed_plugins = true,
    }
  end,
}
