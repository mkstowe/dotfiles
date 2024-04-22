return {
  "echasnovski/mini.starter",
  lazy = false,
  config = function()
    local starter = require "mini.starter"
    starter.setup {
      items = {
        starter.sections.recent_files(5, false, false),
        starter.sections.telescope(),
      },
      header = "",
      footer = "",
    }
  end,
}
