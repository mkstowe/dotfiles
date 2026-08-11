---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "mountain",
}

M.colorify = {
  highlight = {
    hex = not vim.g.vscode,
  },
}

return M
