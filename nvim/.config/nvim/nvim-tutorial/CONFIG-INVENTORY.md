# Config inventory and coverage map

This is a static inventory of the supplied config. The tutorial in `README.md`
is the hands-on companion.

## Startup and framework

- Leader: Space
- Local leader: Space
- Framework: NvChad 2.5
- Plugin manager: lazy.nvim
- Theme: Base46 `mountain`
- Base46 cache files loaded explicitly: `defaults`, `statusline`
- `$HOME/.cargo/bin` is prepended to PATH when `tree-sitter` exists there.
- NvChad options and autocmds are imported.
- Personal keymaps are scheduled after startup.
- Lazy defaults plugins to lazy loading.
- Lazy fallback install colorscheme: `nvchad`.
- Many built-in runtime plugins are disabled for performance, including netrw,
  archive handlers, matchit, tutor, compiler, syntax/synmenu, optwin and others.

## Personal plugin declarations: coding

### stevearc/conform.nvim

Personal formatter map by filetype:

- Lua → stylua
- HTML/CSS/SCSS → prettierd, prettier
- JS/JSX/TS/TSX → prettierd, prettier
- JSON → prettierd, prettier
- YAML → yamlfmt, prettierd, prettier
- GraphQL/Markdown → prettierd, prettier
- Bash/sh → shfmt
- Dockerfile → dockfmt
- Python → black
- SQL → sql-formatter
- C/C++ → clang-format
- C# → csharpier
- QML → qmlformat

Personal mapping: `<leader>ff`, using LSP fallback.

### neovim/nvim-lspconfig

Enabled servers:

`html`, `cssls`, `angularls`, `bashls`, `docker_compose_language_service`,
`dockerls`, `emmet_ls`, `eslint`, `graphql`, `jsonls`, `lua_ls`, `postgres_lsp`,
`pyright`, `sqlls`, `tailwindcss`, `ts_ls`, `yamlls`, `clangd`, `qmlls`.

Each receives NvChad's default LSP capabilities and `on_attach`.

### nvim-treesitter/nvim-treesitter

- Branch: `main`
- Eager (`lazy = false`)
- Install directory: `stdpath("data") .. "/site"`
- Configured parser list: Lua, Bash, Python, JavaScript, TypeScript, HTML, CSS,
  JSON, YAML, Markdown, Markdown inline, C, C#, C++, Dockerfile, GraphQL, HTTP,
  jq, Rasi, regex, SCSS, SQL, TOML, QML/JS.
- Personal FileType autocmd uses the same list to enable the Treesitter
  `indentexpr` when a configured language is detected.

### windwp/nvim-ts-autotag

- Loaded only for `html` by the personal spec.
- Default options.

### danymat/neogen

Filetype-lazy-loaded for TypeScript, Lua, JavaScript, C, shell, C#, C++, Go,
Java, PHP, Kotlin, Python, Ruby, Rust and Vue. Default options. No personal
mapping.

### monaqa/dial.nvim

Eager. Registers a `default` augend group covering integers, hex/binary, hex
colors, ordinal words, number words, many date/time formats, weekdays, months,
letters, booleans, declaration/logical operators and semantic versions.

Important: no personal Dial mapping is installed. `<C-a>` is instead mapped to
Select All. A `dials_by_ft` table exists in config, but the plugin config shown
only explicitly registers `opts.groups`.

## Personal plugin declarations: editor

### LudoPinelli/comment-box.nvim

Installed with plugin defaults. No personal mappings/opts.

### numToStr/Comment.nvim

Eager. Personal mappings:

- `<C-/>` current line in Normal/Insert
- `<C-/>` selected block in Visual

### gbprod/cutlass.nvim

Eager. `cut_key = "x"`, `override_del = true`.

### andyg/leap.nvim (Codeberg URL)

Eager. `add_default_mappings(true)`. Personal `s` and `S` mappings are also
provided for Normal/Visual/Operator-pending.

### chentoast/marks.nvim

Default mappings enabled. `force_write_shada = true`.

### nacro90/numb.nvim

Default options; previews line destinations typed as Ex commands.

### chrisgrieser/nvim-recorder

Default options. Default macro UX includes `q`, `Q`, `<C-q>`, `cq`, `dq`, `yq`
and macro breakpoints.

### roobert/search-replace.nvim

Default options. Personal mappings invoke:

- `SearchReplaceSingleBufferOpen`
- `SearchReplaceSingleBufferCWord`

### tpope/vim-sleuth

No personal options. Automatically infers indentation settings from files.
This can interact with/adjust indentation beyond your FileType defaults.

### sQVe/sort.nvim

Default options; no personal keymap.

### chrisgrieser/nvim-spider

Default options. Personal `w`, `e`, `b` mappings in Normal/Visual/Operator mode.

### ggandor/leap-spooky.nvim

Eager. `paste_on_remote_yank = true`.

### abecodes/tabout.nvim

Default options; no personal keymap override.

## Personal plugin declarations: UI

### dstein64/nvim-scrollview

Default options. Automatic scrollbar/sign behavior.

### folke/twilight.nvim

Loads on `VeryLazy`. Personal mapping `<leader>tw` runs `:Twilight`.

### folke/which-key.nvim

Loads on `VeryLazy`, default options. Personal group labels are added for File,
Toggle, Window, Tab, Search, Git, LSP and Search/Replace.

### folke/zen-mode.nvim

Loads on `VeryLazy`. Personal mapping `<leader>tz` runs `:Zen`.
Inside Zen Mode the config hides signcolumn, number, relativenumber, cursorline
and cursorcolumn. Kitty integration is enabled.

### iamcco/markdown-preview.nvim

Loaded for Markdown. Build command: `cd app && npm install`.

## NvChad / dependency plugins present in lazy-lock.json

These appear in the lockfile but are not all directly declared by the personal
`lua/plugins/*.lua` files. Some are NvChad framework plugins or dependencies:

- LuaSnip
- NvChad
- base46
- cmp-async-path
- cmp-buffer
- cmp-nvim-lsp
- cmp-nvim-lua
- cmp_luasnip
- friendly-snippets
- gitsigns.nvim
- indent-blankline.nvim
- lazy.nvim
- mason.nvim
- menu
- minty
- nvim-autopairs
- nvim-cmp
- nvim-tree.lua
- nvim-web-devicons
- plenary.nvim
- telescope.nvim
- ui
- volt

They are covered in the tutorial primarily through runtime discovery
(`:Telescope keymaps`, `:Telescope commands`, `:Lazy`) rather than pretending
that their mappings/settings are personal declarations in this config.

## Personal autocmds

### TextYankPost

Highlights yanked text with `IncSearch` for 500 ms.

### BufReadPost

Restores the last cursor position from mark `"` if its saved line still exists.

### FileType: two-space indentation

For Lua, JSON, YAML/YML, HTML, XML, CSS/SCSS/Less, JavaScript/TypeScript,
JSX/TSX, Vue, Svelte, Markdown, TOML and Fish:

- `shiftwidth = 2`
- `tabstop = 2`
- `expandtab = true`

Note that vim-sleuth is also installed and can infer indentation from file
contents, so actual local values are worth checking with `:setlocal`.

### FileType: Treesitter indentexpr

Maps current filetype to a Treesitter language, checks the configured parser
list, and enables nvim-treesitter's indent expression when applicable.

### BufWritePost: config reload

Files matching `~/.config/nvim/**/*.lua` are sourced after save.

## Personal keymap groups

### Editing/movement

`j`, `k`, arrows for wrapped lines; Alt-Up/Down line moves; persistent Visual
indent; Escape clears search; smart `n`/`N`; Insert `<C-b>/<C-e>`; Spider
`w/e/b`; paragraph `<C-j>/<C-k>`; save `<C-s>`; select-all `<C-a>`; undo/redo
`<C-z>`, `<C-S-z>`, `U`; Leap `s/S`.

### Windows/tabs

Arrow Ctrl navigation; `<leader>w...` window management;
`<leader><tab>...` tab management.

### Toggle

`<leader>tn`, `tr`, `tw`, `tz`, `td`, `te`.

### Files

`<leader>ff`, `fd`, `fo`, `fO`, `fc`, `fx`, `fl`.

### Search

`<leader>sp`, `sb`, `sh`, `sm`, `si`, `s/`, `sk`, `sc`, `sf`, `sn`, plus Git,
LSP, and Search/Replace subgroups.

## Potentially surprising interactions to test

1. `<C-a>` is Select All, so it shadows the conventional Vim increment command
   and common Dial examples.
2. `s` is Leap, replacing Vim's native substitute-character command.
3. `w/e/b` are Spider motions, not stock Vim word motions.
4. `q/Q` behavior is altered by nvim-recorder's defaults.
5. `x`, delete/change registers and paste behavior are changed by Cutlass.
6. Tab may participate in both inherited completion mappings and Tabout. Test
   Tabout with the completion menu closed.
7. Vim-sleuth can infer indentation even though your FileType autocmd sets
   explicit two-space defaults for many filetypes.
8. Personal LSP Telescope mappings only work when a server is attached and a
   meaningful symbol is under the cursor.
9. Git Telescope/Gitsigns tests need the fixture folder to be a Git repository.
10. Many LSP/formatter declarations require external executables; declarations
    alone do not guarantee those tools are installed.
