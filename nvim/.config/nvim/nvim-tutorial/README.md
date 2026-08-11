# Neovim config tutorial / test bench

This folder is designed around the supplied NvChad 2.5 configuration. Open the
folder itself in Neovim so Telescope, Git, LSP, buffers, file-tree behavior, and
formatting can all be exercised together:

```sh
cd nvim-tutorial
nvim .
```

The exercises are intentionally destructive in places. Keep this as a scratch
copy and reset/re-extract it whenever you want a clean run.

## 0. First-run sanity checks

Start here before debugging an individual feature.

```vim
:checkhealth
:Lazy
:Mason
:Telescope keymaps
:Telescope commands
```

Your config imports NvChad defaults and then adds your own plugins/mappings.
`lua/config/options.lua` only calls `require "nvchad.options"`, so editor
options not mentioned elsewhere mostly come from NvChad rather than personal
overrides.

Your leader and local leader are both Space.

Useful inspection commands while working through this tutorial:

```vim
:verbose map <key>
:verbose nmap <key>
:verbose imap <key>
:set option?
:setlocal shiftwidth? tabstop? expandtab? indentexpr?
:LspInfo
:ConformInfo
:messages
```

## 1. Core movement and editing mappings

Open `editing-playground.txt`.

### Wrapped-line-aware j/k

Make the window narrow enough that the first long paragraph wraps. With no
count, `j`, `k`, Down and Up move by *screen line* (`gj`/`gk`). With a count,
for example `3j`, they move by real buffer lines.

### Paragraph navigation

Use `<C-j>` and `<C-k>` to jump to the next/previous paragraph while recentering
with `zz`.

### Move lines and selections

Try all three modes:

- Normal: `<A-Down>` / `<A-Up>`
- Insert: `<A-Down>` / `<A-Up>` while typing
- Visual: select several lines, then `<A-Down>` / `<A-Up>`

In Visual mode, use `<` and `>` repeatedly. The selection should remain active
because the mapping reselects with `gv`.

### Insert-mode beginning/end

On a nonblank line, enter Insert mode and try `<C-b>` to jump to the first
nonblank character and `<C-e>` to jump to the end.

### Select all, undo, redo

`<C-a>` selects the whole buffer from Normal, Visual, or Insert mode. This is a
personal mapping and notably means `<C-a>` is **not** available as the usual
Dial/Vim increment mapping.

Make an edit, then test `<C-z>` for undo and `<C-S-z>` or `U` for redo.

### Search direction and clearing

Search for `NEEDLE` with `/NEEDLE`. Use `n` and `N`. Your mappings make these
mean visually next/previous relative to the original search direction, including
when the search was started backward with `?NEEDLE`.

Press Escape to clear search highlighting. Your Escape mapping also behaves as
Escape from Insert mode.

### Save

Change the file and press `<C-s>`.

## 2. Comments, delete/cut behavior, and yank highlighting

Open `code-playground.lua` or `code-playground.ts`.

### Comment.nvim

- Normal or Insert: `<C-/>` toggles the current line comment.
- Visual: select several lines and press `<C-/>` to toggle the block linewise.

If your terminal sends a different sequence for Ctrl-/ use `:Telescope keymaps`
or `:verbose map <C-/>` to verify what Neovim receives.

### Yank highlight autocmd

Yank a word with `yiw` or a line with `yy`. The yanked region should briefly
highlight for 500 ms using `IncSearch`.

### cutlass.nvim

This plugin is configured with `cut_key = "x"` and `override_del = true`.
Use the disposable lines in `editing-playground.txt` to compare `x`, `d`, `c`,
`p`, and registers (`:reg`). The point of Cutlass is to separate destructive
"delete" edits from the text you intentionally want available to paste.

A good test is:

1. `yy` a line you want to preserve.
2. Perform a delete/change on another line.
3. `p` and inspect whether your earlier yank is still the paste source.
4. Use `x` on disposable text and inspect `:reg` again.

## 3. Leap, Spider, and remote motions

Open `motion-playground.txt`.

### leap.nvim

Your explicit mappings are:

- `s` in Normal/Visual/Operator-pending: Leap
- `S`: Leap from a window / across windows

Try `s` and target a visible two-character sequence far from the cursor. For
operator-pending behavior, start an operator such as `d` and then use `s` as
the motion.

Create a split with `<leader>w|` and use `S` to test cross-window targeting.
Leap's own default mappings are also enabled by `add_default_mappings(true)`, so
`:Telescope keymaps` is the best way to inspect any extra mappings present in
your installed Leap version.

### nvim-spider

Your `w`, `e`, and `b` are replaced in Normal, Visual and Operator-pending mode
with Spider motions. Test on identifiers like:

```text
HTTPServer response_code someMixedCase XML2Parser foo.bar/baz
```

Compare how movement respects subwords/punctuation rather than treating the
whole identifier as a single Vim word. Then try an operator such as `dw` or
`ce` to verify Spider is used operator-pending too.

### leap-spooky.nvim

This plugin is enabled with `paste_on_remote_yank = true`. It augments remote
operator workflows built around Leap. Because its exact default mappings depend
on the installed plugin version, inspect them with:

```vim
:Telescope keymaps
:help leap-spooky
```

Search for mappings/descriptions containing `spooky`, `remote`, `leap`, `yank`,
or `paste`, then exercise them on repeated target words in
`motion-playground.txt`. The configured behavior to verify is that remote yanks
can paste immediately at the local cursor.

## 4. Marks, macros, numeric previews, sorting, and search/replace

### marks.nvim

`marks.nvim` uses its default mappings and forces ShaDa writes, so marks are
intended to persist across sessions. In any playground file:

1. Set several letter marks with native `ma`, `mb`, etc.
2. Inspect `:marks` and `<leader>sm` (`Telescope marks`).
3. Use `:Telescope keymaps` and search `mark` to see marks.nvim's additional
   default mappings for setting, deleting, previewing, and traversing marks.
4. Quit Neovim, reopen the folder, and verify file marks persisted.

### nvim-recorder

Default setup is used. In Normal mode:

- `q` starts/stops recording into the active macro slot.
- `Q` plays the current macro.
- `<C-q>` switches macro slots.
- `cq` edits the macro, `dq` deletes macros, `yq` yanks a macro.
- `##` can insert a macro breakpoint while recording.

A simple test: put the cursor on the first `macro item` line in
`editing-playground.txt`, press `q`, append ` DONE`, return to Normal mode, move
down one line, press `q` to finish, then use `Q` on following lines.

### numb.nvim

Type an Ex line number such as `:35` but pause before Enter. `numb.nvim` should
preview the destination line while the command line is still active. Cancel with
Escape, then try another number.

### sort.nvim

Open `sorting-playground.txt`. The plugin is using default options. Use
`:Telescope commands` and search for `Sort`, or `:help sort.nvim`, to inspect the
commands exposed by the installed version. Test both whole-line sorting and a
selection with comma-delimited values.

### search-replace.nvim

Your mappings expose two commands:

- `<leader>srr` → `SearchReplaceSingleBufferOpen`
- `<leader>srw` → `SearchReplaceSingleBufferCWord`

Open `search-replace-playground.txt`. Use `<leader>srr` for an interactive
single-buffer replacement. Put the cursor on `ALPHA` and use `<leader>srw` to
start a replacement based on the word under the cursor.

## 5. Dial: increments, constants, dates, colors, semver

Open `dial-playground.md`.

Your Dial config registers a large `default` augend group, including decimal,
hex, binary, hex colors, ordinals, number words, dates/times, weekdays, months,
alphabetic characters, booleans, `let`/`const`, `and`/`or`, `True`/`False`,
`&&`/`||`, and semantic versions.

**There is no Dial keymap in this config.** Your `<C-a>` is Select All, and
`<C-x>` is not mapped to Dial either. Test Dial directly with:

```vim
:lua require('dial.map').manipulate('increment', 'normal')
:lua require('dial.map').manipulate('decrement', 'normal')
```

Put the cursor over each token in `dial-playground.md` and run increment/decrement.
Many entries are cyclic, so repeatedly increment weekdays/months/booleans.

Your config also defines `dials_by_ft`, but the shown plugin setup only registers
`opts.groups`; it does not add mappings that select those per-filetype group
names. Treat the `default` group as the directly testable configured behavior.

## 6. Windows, tabs, buffers, file actions

Use these on any tutorial file.

### Windows

- `<leader>w-` split below
- `<leader>w|` split right
- `<leader>wr` new vertical window
- `<leader>wn` new window
- `<leader>ww` previous/other window
- `<leader>wd` close current window
- `<leader>wx` close all other windows
- `<C-Left/Down/Up/Right>` move between windows

### Tabs

- `<leader><tab><tab>` new tab
- `<leader><tab>n` next
- `<leader><tab>p` previous
- `<leader><tab>b` first
- `<leader><tab>e` last
- `<leader><tab>d` close

### Buffers / files

- `<leader>fo` prompt for a file and open it in a right split
- `<leader>fO` prompt and open below
- `<leader>fc` close buffer
- `<leader>fx` close other buffers, preserving the alternate buffer
- `<leader>fl` list buffers
- `<leader>fd` delete the current file from disk after typing `y` or `yes`

For `<leader>fd`, only use `delete-me.txt`.

NvChad also supplies nvim-tree and tab/buffer UI. Use `:Telescope keymaps` to
inspect its inherited file-tree/buffer mappings rather than assuming they are
personal mappings from this config.

## 7. Toggles, focus modes, diagnostics, and UI

### Number toggles

- `<leader>tn` toggles `number`
- `<leader>tr` toggles `relativenumber`

Check with `:set number? relativenumber?` before/after.

### Twilight / Zen

- `<leader>tw` runs `:Twilight`
- `<leader>tz` runs `:Zen`

Zen Mode is configured to hide the sign column, absolute/relative line numbers,
cursorline, and cursorcolumn inside the Zen window. Kitty integration is enabled.

`focus-playground.md` has enough prose to make Twilight's dimming behavior
obvious.

### Diagnostics

In `code-playground.ts`, if `ts_ls`/eslint are installed and attached, there are
intentional errors/warnings. Use:

- `<leader>td` disable diagnostics
- `<leader>te` enable diagnostics

The mapping also sends a notification confirming the state.

### nvim-scrollview

Use any long file (`scroll-playground.txt`). A vertical scrollbar should appear
automatically. Try:

```vim
:ScrollViewToggle
:ScrollViewLegend
:ScrollViewDisable
:ScrollViewEnable
```

Search for `SCROLL_NEEDLE` so search signs can appear in the scrollbar. Marks
and diagnostics may also appear as signs depending on Neovim/plugin support.

### Theme / colorify

`chadrc.lua` selects the `mountain` Base46 theme. NvChad's colorify feature is
enabled for hex colors unless running under VS Code (`vim.g.vscode`). Open
`dial-playground.md` and inspect the hex colors for inline highlighting.

## 8. Telescope search workflows

These are your explicit Telescope mappings:

- `<leader>sp` live grep
- `<leader>sb` buffers
- `<leader>sh` help tags
- `<leader>sm` marks
- `<leader>si` fuzzy find in current buffer
- `<leader>s/` find files
- `<leader>sk` keymaps
- `<leader>sc` commands
- `<leader>sf` functions
- `<leader>sn` notifications
- `<leader>sgc` Git commits
- `<leader>sgb` Git branches
- `<leader>sgs` Git status
- `<leader>slr` LSP references
- `<leader>sli` LSP implementations
- `<leader>sld` LSP definitions

The first nine work without a language server. Git pickers need a Git repository;
LSP pickers need an attached server and a symbol under the cursor.

Try searching `TELESCOPE_NEEDLE` with both `<leader>sp` and `<leader>si`.

## 9. LSP test bench

Your enabled servers are:

```text
html cssls angularls bashls docker_compose_language_service dockerls emmet_ls
eslint graphql jsonls lua_ls postgres_lsp pyright sqlls tailwindcss ts_ls yamlls
clangd qmlls
```

Whether each attaches depends on the executable being installed and the file / project
having a recognizable root. Use `:LspInfo` in each fixture.

### TypeScript

Open `code-playground.ts`. Put the cursor on `formatUser` or `User` and try the
inherited NvChad LSP mappings shown by `<leader>sk`, plus your Telescope LSP
mappings `<leader>sld`, `<leader>slr`, and `<leader>sli`.

### HTML/CSS

Open `autotag-playground.html`. This can exercise `html`, `cssls`, `emmet_ls`,
Tailwind (if the project context is sufficient), Treesitter, formatting, and
`nvim-ts-autotag`.

### Lua

Open `code-playground.lua` for `lua_ls`, Treesitter, formatting, comments, and
Neogen.

## 10. Treesitter, indentation, autotags, autopairs, completion

### Treesitter parser list

Your config lists parsers for Lua, Bash, Python, JavaScript, TypeScript, HTML,
CSS, JSON, YAML, Markdown/inline Markdown, C, C#, C++, Dockerfile, GraphQL, HTTP,
jq, Rasi, regex, SCSS, SQL, TOML and QML/JS.

On FileType, your autocmd checks this list and, if the current filetype maps to a
listed parser, sets:

```text
indentexpr=v:lua.require'nvim-treesitter'.indentexpr()
```

Inspect with `:setlocal indentexpr?`.

### Two-space indentation autocmd

For Lua, JSON, YAML/YML, HTML, XML, CSS/SCSS/Less, JS/TS/JSX/TSX, Vue, Svelte,
Markdown, TOML and Fish, your FileType autocmd sets:

```text
shiftwidth=2
tabstop=2
expandtab
```

Check `code-playground.lua`, `code-playground.ts`, `autotag-playground.html`,
and this README with `:setlocal sw? ts? et?`.

### nvim-ts-autotag

This plugin is only lazy-loaded for `html` in your declaration. In
`autotag-playground.html`, type a new opening tag and test automatic closing /
paired renaming behavior supported by the plugin.

### nvim-autopairs and nvim-cmp

These come from NvChad's inherited plugin set, not your personal plugin files.
In a code fixture, type `(`, `[`, `{`, quotes, and function calls to exercise
pairing. Start typing identifiers to exercise completion/snippets. Inspect exact
completion mappings with `<leader>sk` because those are inherited NvChad defaults.

### tabout.nvim

`tabout.nvim` uses default options. Put the cursor inside nested pairs such as:

```text
call(alpha(beta[gamma]))
```

Try Tab / Shift-Tab while in Insert mode to move out of delimiters. Completion
may also use Tab depending on inherited NvChad mappings; if a completion menu is
open, test Tabout with the menu closed so the behavior is unambiguous.

## 11. Formatting with conform.nvim

`<leader>ff` runs Conform with `lsp_fallback = true`.

Configured formatters:

```text
lua                 stylua
html/css/scss        prettierd, prettier
js/jsx/ts/tsx        prettierd, prettier
json                 prettierd, prettier
yaml                 yamlfmt, prettierd, prettier
graphql/markdown     prettierd, prettier
bash/sh              shfmt
dockerfile           dockfmt
python               black
sql                  sql-formatter
c/cpp                clang-format
cs                   csharpier
qml                  qmlformat
```

Each fixture contains deliberately awkward spacing. Open one, run `:ConformInfo`
to see which formatter is available, then press `<leader>ff`.

## 12. Neogen documentation generation

`neogen` is loaded for TypeScript, Lua, JavaScript, C, shell, C#, C++, Go, Java,
PHP, Kotlin, Python, Ruby, Rust and Vue. No personal Neogen mapping is defined.

In `code-playground.lua` or `code-playground.ts`, put the cursor inside a
function and run:

```vim
:Neogen func
```

Use `:Neogen class`, `:Neogen type`, or `:Neogen file` where appropriate and
`:help neogen` for language-specific support.

## 13. Markdown preview

Open `markdown-preview-playground.md`; the plugin is filetype-lazy-loaded for
Markdown. Run:

```vim
:MarkdownPreview
:MarkdownPreviewStop
:MarkdownPreviewToggle
```

The plugin's build step is `cd app && npm install`, so Node/npm must be available
and the Lazy build must have succeeded. The fixture includes headings, lists,
code, a table, task boxes, links and Mermaid-like fenced content to make browser
rendering easy to inspect.

## 14. Git / gitsigns / Telescope Git

NvChad supplies `gitsigns.nvim`; your config supplies Telescope Git pickers.
Initialize this tutorial folder as a repo:

```sh
git init
git add .
git commit -m "tutorial baseline"
```

Then modify a few lines in `git-playground.txt` and delete/add others. Verify
Gitsigns' gutter indicators and use `<leader>sgs` for status.

Create a branch and another commit to exercise:

```vim
<leader>sgb
<leader>sgc
```

Use `<leader>sk` and search `git`/`gitsigns` to learn the inherited NvChad
mappings for hunk navigation, preview, stage/reset, and blame.

## 15. Autocmd tests

### Restore cursor position

Open a file, move somewhere far down, save/quit, then reopen it. `BufReadPost`
restores mark `"` when the saved line still exists.

### Reload config after saving Lua

Your `BufWritePost` autocmd sources files matching:

```text
~/.config/nvim/**/*.lua
```

To test safely, edit a harmless config Lua file, save it, and check `:messages`.
Remember that sourcing an individual plugin spec/config file is not always the
same as rebuilding the entire Lazy plugin graph; structural plugin changes may
still require a restart or Lazy reload.

### Yank highlight

Covered earlier: every yank triggers a 500 ms highlight.

## 16. lazy.nvim / runtime behavior

Your Lazy config defaults plugins to lazy loading, installs with `nvchad` as the
fallback colorscheme, and customizes Lazy UI icons. A substantial set of built-in
runtime plugins is disabled (including netrw, gzip/tar/zip handlers, matchit,
spellfile plugin, tutor, compiler and others) for startup/runtime performance.

Use `:Lazy` to inspect which plugins are loaded before and after opening Markdown,
HTML, invoking Zen/Twilight, using Telescope, etc. This is one of the best ways
to understand the actual load boundaries of this setup.

## 17. Which-key groups

Press Space and pause. Your config explicitly registers groups for:

```text
<leader>f       File
<leader>t       Toggle
<leader>w       Window
<leader><tab>   Tab
<leader>s       Search
<leader>sg      Git
<leader>sl      LSP
<leader>sr      Search and Replace
```

Use this together with `<leader>sk` as the live discoverability layer for both
your mappings and inherited NvChad/plugin mappings.

## 18. Coverage checklist

By the time you have worked through the folder you should have exercised:

- NvChad theme/UI, inherited options, completion, autopairs, nvim-tree, gitsigns
- Lazy plugin inspection and filetype/event lazy loading
- Comment.nvim and yank highlighting
- Cutlass delete/cut semantics
- Leap, Leap Spooky, Spider
- Marks persistence and Telescope marks
- Recorder macros and macro slots
- Numb line-number previews
- Search/replace UI
- Sort
- Dial constants/dates/colors/semver via direct Lua call
- Window/tab/buffer/file mappings
- line-number, diagnostics, Twilight and Zen toggles
- Telescope file/buffer/help/keymap/command/function/notification/Git/LSP pickers
- LSP attachment and navigation
- Treesitter highlighting/indent integration
- two-space FileType indentation autocmd
- HTML autotags
- Tabout
- Conform formatting / LSP fallback
- Neogen doc generation
- Markdown browser preview
- Scrollview and signs
- cursor restore and config reload autocmds

Keep `:Telescope keymaps`, `:Telescope commands`, `:Lazy`, `:LspInfo`, and
`:ConformInfo` close at hand. They turn this folder from a static cheat sheet
into a way to inspect the *actual* runtime state of your exact installation.
