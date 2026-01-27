local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    html = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    scss = { "prettierd", "prettier" },
    javascript = { "prettierd", "prettier" },
    javascriptreact = { "prettierd", "prettier" },
    typescript = { "prettierd", "prettier" },
    typescriptreact = { "prettierd", "prettier" },
    json = { "prettierd", "prettier" },
    yaml = { "yamlfmt", "prettierd", "prettier" },
    graphql = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    dockerfile = { "dockfmt" },
    python = { "black" },
    sql = { "sql-formatter" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    cs = { "csharpier" }
  },
}

return options
