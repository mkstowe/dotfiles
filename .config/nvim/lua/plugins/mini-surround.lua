return {
  "echasnovski/mini.surround",
  lazy = false,
  config = function()
    require("mini.surround").setup {
      mappings = {
        add = "<leader>za",
        delete = "<leader>zd",
        find = "<leader>zf",
        find_left = "<leader>zF",
        highlight = "<leader>zh",
        replace = "<leader>zc",
        update_n_lines = "<leader>zn",
      },
    }
  end,
}
