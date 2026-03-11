local default_config = require "nvchad.configs.lspconfig"

local servers = {
  "html",
  "cssls",
  "angularls",
  "bashls",
  "docker_compose_language_service",
  "dockerls",
  "emmet_ls",
  "eslint",
  "graphql",
  "jsonls",
  "lua_ls",
  "postgres_lsp",
  "pyright",
  "sqlls",
  "tailwindcss",
  "ts_ls",
  "yamlls",
  "clangd",
  "qmlls",
}

for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = default_config.capabilities,
    on_attach = default_config.on_attach,
  })
end

vim.lsp.enable(servers)
