local autocmd = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("user_config", { clear = true })

-- highlight yank selection
autocmd("TextYankPost", {
  group = group,
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 500 }
  end,
})

autocmd("BufReadPost", {
  group = group,
  desc = "Restore the last cursor position",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- set indent for file types
autocmd("FileType", {
  group = group,
  desc = "Use two-space indentation for web and config files",
  pattern = {
    "lua",
    "json",
    "yaml",
    "yml",
    "html",
    "xml",
    "css",
    "scss",
    "less",
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "markdown",
    "toml",
    "fish",
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- nvim-treesitter's main branch delegates indentation to Neovim.
autocmd("FileType", {
  group = group,
  desc = "Use Treesitter indentation when a configured parser is available",
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    local parsers = require("config.plugins.treesitter").ensure_installed
    if lang and vim.list_contains(parsers, lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- reload nvim config on change
autocmd("BufWritePost", {
  group = group,
  desc = "Reload edited Neovim configuration",
  pattern = "~/.config/nvim/**/*.lua",
  command = "source <afile>",
})
