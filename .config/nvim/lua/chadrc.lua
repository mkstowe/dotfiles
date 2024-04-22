-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = dofile(os.getenv "HOME" .. "/.cache/wal/nvim-colors.lua")
M.ui.hl_override = {
  Visual = {
    fg = { "black", 0 },
  },
  Comment = {
    italic = true,
  },
  ["@comment"] = {
    italic = true,
  },
  IncSearch = {
    bg = { "green", 0 },
    fg = { "black", 0 },
  },
  Search = {
    bg = { "green", 0 },
    fg = { "black", 0 },
  },
  Type = {
    fg = { "green", 0 },
  },
}

M.ui.theme = "aquarium"

M.ui.statusline = {
  theme = "default",
  separator_style = "round",
  order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "cwd" },
}

return M
