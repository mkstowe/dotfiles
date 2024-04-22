return {
  "dmmulroy/ts-error-translator.nvim",
  ft = { "typescript" },
  config = function()
    require("ts-error-translator").setup()
  end,
}
