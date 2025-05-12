local autocmd = vim.api.nvim_create_autocmd

-- highlight yank selection
autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Hightlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 500 }
  end,
})

autocmd("BufReadPost", {
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
  pattern = {
    "lua", "json", "yaml", "yml", "html", "xml", "css", "scss", "less",
    "javascript", "typescript", "javascriptreact", "typescriptreact",
    "vue", "svelte", "markdown", "toml", "fish"
  },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- reload nvim config on change
autocmd("BufWritePost", {
  pattern = "~/.config/nvim/**/*.lua",
  command = "source <afile>",
})

