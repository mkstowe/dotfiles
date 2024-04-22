return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
  opts = function()
    return {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "angular-language-server",
        "eslint-lsp",
        "jq",
        "json-lsp",
        "shellcheck",
        "typescript-language-server",
        "yaml-language-server",
        "pyright",
        "quick-lint-js",
      },
      PATH = "skip",
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = " 󰚌",
        },
        keymaps = {
          toggle_server_expand = "<CR>",
          install_server = "i",
          update_server = "u",
          check_server_version = "c",
          update_all_servers = "U",
          check_outdated_servers = "C",
          uninstall_server = "X",
          cancel_installation = "<C-c>",
        },
      },
      max_concurrent_installers = 10,
    }
  end,
  config = function(_, opts)
    dofile(vim.g.base46_cache .. "mason")
    require("mason").setup(opts)

    vim.api.nvim_create_user_command("MasonInstallAll", function()
      if opts.ensure_installed and #opts.ensure_installed > 0 then
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end
    end, {})
    vim.g.mason_binaries_list = opts.ensure_installed
  end,
}
