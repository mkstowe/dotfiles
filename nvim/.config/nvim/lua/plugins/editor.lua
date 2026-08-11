return {
  { "LudoPinelli/comment-box.nvim" },
  { "numToStr/Comment.nvim", lazy = false },
  {
    "gbprod/cutlass.nvim",
    lazy = false,
    opts = { cut_key = "x", override_del = true },
  },
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    lazy = false,
    config = function()
      require("leap").add_default_mappings(true)
    end,
  },
  { "chentoast/marks.nvim", opts = { default_mappings = true, force_write_shada = true } },
  { "nacro90/numb.nvim", opts = {} },
  { "chrisgrieser/nvim-recorder", opts = {} },
  { "roobert/search-replace.nvim", opts = {} },
  { "tpope/vim-sleuth" },
  { "sQVe/sort.nvim", opts = {} },
  { "chrisgrieser/nvim-spider", opts = {} },
  {
    "ggandor/leap-spooky.nvim",
    lazy = false,
    opts = { paste_on_remote_yank = true },
  },
  { "abecodes/tabout.nvim", opts = {} },
}
