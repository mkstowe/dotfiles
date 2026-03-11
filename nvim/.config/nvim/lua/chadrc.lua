---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "mountain",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.colorify = {
  highlight = {
    hex = not vim.g.vscode
  }
}
-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
