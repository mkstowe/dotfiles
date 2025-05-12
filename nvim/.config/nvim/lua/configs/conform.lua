local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    graphql = { "prettier" },
    markdown = { "prettier" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    dockerfile = { "dockfmt" },
    python = { "black" },
    sql = { "sql-formatter" },
  },
}

return options
