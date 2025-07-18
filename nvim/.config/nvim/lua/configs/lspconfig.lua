local default_config = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

-- capabilities shared with nvim-cmp
local capabilities = default_config.capabilities

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
  "clangd"
}
vim.lsp.enable(servers)

for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
    on_attach = default_config.on_attach,
  }
end
