# Neovim config

Personal Neovim configuration built on NvChad 2.5 and lazy.nvim.

## Layout

```text
init.lua                    Bootstrap and startup order
lua/chadrc.lua              NvChad theme and UI settings
lua/config/                 Editor options, autocmds, and keymaps
lua/config/plugins/         Detailed plugin settings
lua/plugins/                Plugin declarations grouped by purpose
```

Plugin declarations belong in `lua/plugins/coding.lua`, `editor.lua`, or
`ui.lua`. Keep larger configuration tables in `lua/config/plugins/` so plugin
specifications remain easy to scan.

## Maintenance

- Run `:Lazy` to inspect and update plugins.
- Run `:Mason` to manage language servers and formatting tools.
- Run `:checkhealth` after changing plugins or external toolingaaa.
