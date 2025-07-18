local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Comments
map({ "n", "i" }, "<C-/>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment line", remap = true })
map("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment block", remap = true })

-- Visual line-aware navigation
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
map("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- Move lines
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Indent persistent in visual
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Clear search highlights
map({ "n", "i" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search and escape" })

-- Smarter search navigation
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true })
map("o", "n", "'Nn'[v:searchforward]", { expr = true })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true })
map("o", "N", "'nN'[v:searchforward]", { expr = true })

-- Insert mode line start/end
map("i", "<C-b>", "<ESC>^i", { desc = "Go to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })

-- Leap
map({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap", remap = true })
map({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)", { desc = "Leap from window", remap = true })

-- Spider motions
map({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
map({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
map({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")

-- Paragraph navigation
map("n", "<C-j>", "}zz", { desc = "Next paragraph" })
map("n", "<C-k>", "{zz", { desc = "Previous paragraph" })

-- Save
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Select all
map({ "n", "v", "i" }, "<C-a>", "ggVG", { desc = "Select all" })

-- Undo/Redo
map({ "n", "v", "i" }, "<C-z>", "u", { desc = "Undo" })
map({ "n", "v", "i" }, "<C-S-z>", "<C-r>", { desc = "Redo" })
map({ "n", "v" }, "U", "<C-r>", { desc = "Redo" })

-- Tabs
map("n", "<leader><tab><tab>", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader><tab>n", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader><tab>b", "<cmd>tabfirst<CR>", { desc = "First tab" })
map("n", "<leader><tab>e", "<cmd>tablast<CR>", { desc = "Last tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<CR>", { desc = "Close tab" })

-- Window management
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split right" })
map("n", "<leader>wr", "<cmd>vnew<CR>", { desc = "New window right" })
map("n", "<leader>wn", "<C-W>n", { desc = "New window" })
map("n", "<leader>wx", "<cmd>only<CR>", { desc = "Close other windows" })

-- Toggle options
map("n", "<leader>tn", "<cmd>set nu!<CR>", { desc = "Toggle line numbers" })
map("n", "<leader>tr", "<cmd>set rnu!<CR>", { desc = "Toggle relative line numbers" })
map("n", "<leader>tt", function()
  require("ranger-nvim").open(true)
end, { desc = "Toggle Ranger" })
map("n", "<leader>tw", "<cmd>Twilight<CR>", { desc = "Toggle Twilight" })
map("n", "<leader>tz", "<cmd>Zen<CR>", { desc = "Toggle Zen Mode" })

-- Diagnostics
map("n", "<leader>td", function()
  vim.diagnostic.disable()
  vim.notify("Diagnostics disabled", vim.log.levels.INFO)
end, { desc = "Disable diagnostics" })
map("n", "<leader>te", function()
  vim.diagnostic.enable()
  vim.notify("Diagnostics enabled", vim.log.levels.INFO)
end, { desc = "Enable diagnostics" })

-- File formatting and close
map("n", "<leader>ff", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format file" })
map("n", "<leader>fd", function()
  local confirm = vim.fn.input "Delete? "
  if confirm == "y" or confirm == "yes" then
    vim.cmd "!rm %"
    vim.cmd "bd"
  end
end, { desc = "Delete file" })
map("n", "<leader>fo", function()
  local filename = vim.fn.input("File: ", "", "file")
  if filename ~= "" then
    vim.cmd("vsp " .. filename)
  end
end, { desc = "Open file right" })
map("n", "<leader>fO", function()
  local filename = vim.fn.input("File: ", "", "file")
  if filename ~= "" then
    vim.cmd("sp " .. filename)
  end
end, { desc = "Open file below" })
map("n", "<leader>fc", "<cmd>bd<CR>", { desc = "Close file" })
map("n", "<leader>fx", "<cmd>%bd|e#<CR>", { desc = "Close other files" })
map("n", "<leader>fl", "<cmd>ls<CR>", { desc = "List buffers" })

-- Search (Telescope)
map("n", "<leader>sp", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Marks" })
map("n", "<leader>si", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "In file" })
map("n", "<leader>s/", "<cmd>Telescope find_files<cr>", { desc = "Files" })
map("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>sc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
map("n", "<leader>sf", "<cmd>Telescope functions<cr>", { desc = "Functions" })
map("n", "<leader>sn", "<cmd>Telescope notify<cr>", { desc = "Notifications" })
map("n", "<leader>sgc", "<cmd>Telescope git_commits<cr>", { desc = "Commits" })
map("n", "<leader>sgb", "<cmd>Telescope git_branches<cr>", { desc = "Branches" })
map("n", "<leader>sgs", "<cmd>Telescope git_status<cr>", { desc = "Status" })
map("n", "<leader>slr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
map("n", "<leader>sli", "<cmd>Telescope lsp_implementations<cr>", { desc = "Implementations" })
map("n", "<leader>sld", "<cmd>Telescope lsp_definitions<cr>", { desc = "Definitions" })
map("n", "<leader>srr", "<cmd>SearchReplaceSingleBufferOpen<cr>", { desc = "Search and replace" })
map("n", "<leader>srw", "<cmd>SearchReplaceSingleBufferCWord<cr>", { desc = "Search and replace word under cursor" })
