return {
  "chentoast/marks.nvim",
  lazy = false,
  config = function()
    require("marks").setup {
      default_mappings = true,
      force_write_shada = true,
    }
  end,
}
