return {
  "echasnovski/mini.align",
  lazy = false,
  config = function()
    require("mini.align").setup {
      mappings = {
        start_with_preview = "<leader>~a",
      },
    }
  end,
}
