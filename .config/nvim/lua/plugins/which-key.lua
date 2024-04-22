return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  cmd = "WhichKey",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    dofile(vim.g.base46_cache .. "whichkey")
    require("which-key").setup {
      plugins = {
        marks = true,
        registers = false,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      operators = { gc = "Comments" },
      key_labels = {
        ["<space>"] = "<SPACE>",
        ["<tab>"] = "<TAB>",
      },
      motions = {
        count = true,
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      popup_mappings = {
        scroll_down = "<C-d>",
        scroll_up = "<C-u>",
      },
      window = {
        border = "single",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 0,
        zindex = 1000,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      ignore_missing = false,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },
      show_help = true,
      show_keys = true,
      triggers = "auto",
      triggers_nowait = {
        "`",
        "'",
        "g`",
        "g'",
        '"',
        "<C-r>",
        "z=",
      },
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
      disable = {
        buftypes = {},
        filetypes = {},
      },
    }
  end,
}
