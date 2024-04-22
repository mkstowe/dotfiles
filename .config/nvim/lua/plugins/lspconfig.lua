return {
  "neovim/nvim-lspconfig",
  event = "User FilePost",
  config = function()
    -- require("nvchad.configs.lspconfig").defaults()
    local lspconfig = require "lspconfig"
    local servers = {
      "angularls",
      "bashls",
      "cssls",
      "eslint",
      "graphql",
      "html",
      "jsonls",
      "lua_ls",
      "pyright",
      "sqlls",
      "tsserver",
      "yamlls",
    }

    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = function(client, bufnr)
          if require("nvconfig").ui.lsp.signature and client.server_capabilities.signatureHelpProvider then
            require("nvchad.lsp.signature").setup(client, bufnr)
          end
        end,
        on_init = function(client, _)
          if client.supports_method "textDocument/semanticTokens" then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      }
    end
  end,
}
