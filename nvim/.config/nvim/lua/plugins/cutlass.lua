return {
  "gbprod/cutlass.nvim",
  lazy = false,
  config = function()
    require("cutlass").setup {
      cut_key = "x",
      override_del = true,
    }
  end,
}

