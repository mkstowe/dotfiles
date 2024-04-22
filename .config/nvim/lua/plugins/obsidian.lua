return {
  "epwalsh/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("obsidian").setup {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/notes",
        },
      },
    }
  end,
}
