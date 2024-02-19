local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Comments
map({ "n", "i" }, "<C-/>", "<Plug>(comment_toggle_linewise_current)", { desc = "Comment line" })
map("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment visual block" })

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window
map("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- Resize window
map("n", "<C-A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search
map({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Saner search keys
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Telescope
-- map('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- map('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- map('n', '<leader>/', function()
-- You can pass additional configuration to telescope to change theme, layout, etc.
-- require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
-- winblend = 10,
-- previewer = false,
-- })
-- end, { desc = '[/] Fuzzily search in current buffer' })

-- map('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
-- map('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- map('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- map('n', '<leader>sgr', require('telescope.builtin').live_grep, { desc = '[S]earch by [Gr]ep' })
-- map('n', '<leader>sdi', require('telescope.builtin').diagnostics, { desc = '[S]earch [Di]agnostics' })
-- map('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })
-- map('n', '<leader>sf', require('telescope.builtin').treesitter, { desc = '[S]earch [F]unctions' })
-- map('n', '<leader>sr', require('telescope.builtin').lsp_references, { desc = '[S]earch [R]eferences' })
-- map('n', '<leader>si', require('telescope.builtin').lsp_implementations,
-- { desc = '[S]earch [I]mplementations' })
-- map('n', '<leader>sd', require('telescope.builtin').lsp_definitions, { desc = '[S]earch [D]efinitions' })
-- map('n', '<leader>sgc', require('telescope.builtin').git_commits, { desc = '[S]earch [G]it [C]ommits' })
-- map('n', '<leader>sgb', require('telescope.builtin').git_branches, { desc = '[S]earch [G]it [B]ranches' })

-- Yanky
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Yanky - [P]ut after" })
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Yanky - put before" })
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Yanky - GPut after" })
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Yanky - GPut before" })
map("n", "<c-n>", "<Plug>(YankyCycleForward)", { desc = "Yanky - cycle forward" })
map("n", "<c-p>", "<Plug>(YankyCycleBackward)", { desc = "Yanky - cycle backward" })

-- Easy align
map({ "n", "x" }, 'ga', '<Plug>(EasyAlign)', { desc = "Easy Align" })

-- Marks
map({ "n" }, "<c-m>", "<Plug>(Marks-next)", { desc = "Next mark" })
map({ "n" }, "<c-s-m>", "<Plug>(Marks-prev)", { desc = "Previous mark" })
map({ "n" }, "<c-s-p>", "<Plug>(Marks-preview)", { desc = "Preview mark" })

-- Notify
map({ "n", "v" }, "<leader>dn",
  function()
    require('notify').dismiss({ silent = true, pending = true })
  end,
  { desc = "Dismiss notifications" })
map({ "n", "v" }, "<leader>sn", ":Telescope notify<CR>", { desc = "[S]earch [N]otification history" })

lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["s"] = {
  name = "Search",
  b = { "<cmd>lua require('telescope.builtin').buffers{}<cr>", "[S]earch [B]uffers" },
  c = { "<cmd>lua require('telescope.builtin').commands{}<cr>", "[S]earch [C]ommands" },
  d = { "<cmd>lua require('telescope.builtin').diagnostics{}<cr>", "[S]earch [D]iagnostics" },
  f = { "<cmd>lua require('telescope.builtin').treesitter{}<cr>", "[S]earch [F]unctions" },
  h = { "<cmd>lua require('telescope.builtin').help_tags{}<cr>", "[S]earch [H]elp" },
  k = { "<cmd>lua require('telescope.builtin').keymaps{}<cr>", "[S]earch [K]eymaps" },
  m = { "<cmd>lua require('telescope.builtin').marks{}<cr>", "[S]earch [M]arks" },
  o = { "<cmd>lua require('telescope.builtin').vim_options{}<cr>", "[S]earch [O]ptions" },
  p = { "<cmd>lua require('telescope.builtin').live_grep{}<cr>", "[S]earch by gre[P]" },
  r = { "<cmd>lua require('telescope.builtin').registers{}<cr>", "[S]earch [R]egisters" },
  w = { "<cmd>lua require('telescope.builtin').grep_string{}<cr>", "[S]earch current [W]ord" },
  ["<space>"] = { "<cmd>lua require('telescope.builtin').find_files{}<cr>", "[S]earch Files" },
  ["/"] = { function() require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false }) end,
    "[S]earch in current buffer" },
  ["?"] = { "<cmd>lua require('telescope.builtin').oldfiles{}<cr>", "[S]earch recent files" },

  l = { name = "LSP" },
  ["lr"] = { "<cmd>lua require('telescope.builtin').lsp_references{}<cr>", "[S]earch [L]sp [R]eferences" },
  ["li"] = { "<cmd>lua require('telescope.builtin').lsp_implementations{}<cr>", "[S]earch [L]sp [I]mplementations" },
  ["ld"] = { "<cmd>lua require('telescope.builtin').lsp_definitions{}<cr>", "[S]earch [L]sp [D]efinitions" },

  g = { name = "Git" },
  ["gb"] = { "<cmd>lua require('telescope.builtin').git_branches{}<cr>", "[S]earch [G]it [B]ranches" },
  ["gc"] = { "<cmd>lua require('telescope.builtin').git_commits{}<cr>", "[S]earch [G]it [C]ommits" },
  ["gs"] = { "<cmd>lua require('telescope.builtin').git_status{}<cr>", "[S]earch [G]it [S]tatus" },
}
