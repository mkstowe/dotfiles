return {
  "danymat/neogen",
  -- lazy = false,
  ft = {
    "typescript",
    "lua",
    "javascript",
    "c",
    "sh",
    "cs",
    "cpp",
    "go",
    "java",
    "php",
    "kotlin",
    "python",
    "ruby",
    "rust",
    "vue",
  },
  config = function()
    require("neogen").setup {}
  end,
}
