local wk = require "which-key"
wk.add {
  { "<leader>f", group = "File" },
  { "<leader>t", group = "Toggle" },
  { "<leader>w", group = "Window" },
  { "<leader><tab>", group = "Tab" },
  { "<leader>s", group = "Search" },
  { "<leader>sg", group = "Git" },
  { "<leader>sl", group = "LSP" },
  { "<leader>sr", group = "Search and Replace" },
}
