vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

local cargo_bin = vim.fn.expand "$HOME/.cargo/bin"
if vim.fn.executable(cargo_bin .. "/tree-sitter") == 1 then
  vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, require "config.lazy")

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "config.options"
require "config.autocmds"
require "nvchad.autocmds"

vim.schedule(function()
  require "config.keymaps"
end)
