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
map({ "v" }, "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment visual block" })

-- Better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window
map("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- Move lines
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

-- Movement
map("i", "<C-b>", "<ESC>^i", { desc = "Go to beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Go to end of line" })
map({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
map({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })
map({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
map({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
map({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")

local harpoon = require "harpoon"
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

local wk = require "which-key"

-- NORMAL
wk.register({
  ["<leader>"] = {
    s = {
      name = "Search",
      p = { "<cmd>Telescope live_grep<CR>", "[S]earch gre[P]" },
      b = { "<cmd>Telescope buffers<CR>", "[S]earch [B]uffers" },
      h = { "<cmd>Telescope help_tags<CR>", "[S]earch [H]elp" },
      m = { "<cmd>Telescope marks<CR>", "[S]earch [M]arks" },
      i = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "[S]earch [I]n file" },
      ["/"] = { "<cmd>Telescope find_files<CR>", "[S]earch files" },
      k = { "<cmd>Telescope keymaps<CR>", "[S]earch [K]eymaps" },
      c = { "<cmd>Telescope commands<CR>", "[S]earch [C]ommands" },
      f = { "<cmd>Telescope functions<CR>", "[S]earch [F]unctions" },
      n = { "<cmd>Telescope notify<CR>", "[S]earch [N]otification history" },
      g = {
        name = "Git",
        c = { "<cmd>Telescope git_commits<CR>", "[S]earch [G]it [C]ommits" },
        b = { "<cmd>Telescope git_branches<CR>", "[S]earch [G]it [B]ranches" },
        s = { "<cmd>Telescope git_status<CR>", "[S]earch [G]it [S]tatus" },
      },
      l = {
        name = "LSP",
        r = { "<cmd>Telescope lsp_references<CR>", "[S]earch [L]sp [R]eferences" },
        i = { "<cmd>Telescope lsp_implementations<CR>", "[S]earch [L]sp [I]mplementations" },
        d = { "<cmd>Telescope lsp_definitions<CR>", "[S]earch [L]sp [D]efinitions" },
      },
      r = {
        name = "Search and Replace",
        r = { "<cmd>SearchReplaceSingleBufferOpen<CR>", "Search and replace" },
        w = { "<cmd>SearchReplaceSingleBufferCWord<CR>", "Search and replace word under cursor" },
      },
    },
    f = {
      name = "File",
      m = {
        function()
          require("conform").format { lsp_fallback = true }
        end,
        "[F]or[M]at file",
      },
      d = {
        function()
          local confirm = vim.fn.input "Delete? "
          if confirm == "y" or confirm == "yes" then
            vim.cmd "!rm %"
            vim.cmd "bd"
          end
        end,
        "Delete file",
      },
      O = {
        function()
          local filename = vim.fn.input("File: ", "", "file")
          if filename == "" then
            return
          end
          vim.cmd("sp " .. filename)
        end,
        "Open file below",
      },
      o = {
        function()
          local filename = vim.fn.input("File: ", "", "file")
          if filename == "" then
            return
          end
          vim.cmd("vsp " .. filename)
        end,
        "Open file to right",
      },
      c = { "<cmd>bd<CR>", "[F]ile close" },
      x = { "<cmd>%bd|e#<CR>", "Close other files" },
      l = { "<cmd>ls<CR>", "[F]iles [L]ist" },
    },
    m = {
      name = "Marks",
      n = { "<Plug>(Marks-next)", "[M]arks [N]ext" },
      p = { "<Plug>(Marks-previous)", "[M]arks [P]revious" },
      v = { "<Plug>(Marks-preview)", "[M]arks pre[V]iew" },
      d = { "<cmd>delm!<CR>", "[M]arks [D]elete all" },
    },
    n = {
      name = "Notifications",
      d = {
        function()
          require("notify").dismiss { pending = true }
        end,
        "[N]otifications [D]ismiss",
      },
    },
    t = {
      name = "Toggle",
      n = { "<cmd>set nu!<CR>", "[T]oggle line [N]umbers" },
      r = { "<cmd>set rnu!<CR>", "[T]oggle [R]elative line numbers" },
      t = {
        function()
          require("ranger-nvim").open(true)
        end,
        "[T]oggle [T]ree",
      },
      w = { "<cmd>Twilight<CR>", "[T]oggle T[W]ilight" },
      z = { "<cmd>Zen<CR>", "[T]oggle [Z]en mode" },
    },
    w = {
      name = "Windows",
      w = { "<C-W>p", "Other [W]indow" },
      d = { "<C-W>c", "[W]indow [D]elete" },
      ["-"] = { "<C-W>s", "Split current [W]indow below" },
      ["|"] = { "<C-W>v", "Split current [W]indow right" },
      r = { "<cmd>vnew<CR>", "New [W]indow to [R]ight" },
      n = { "<C-W>n", "[W]indow [N]ew" },
      x = { "<cmd>only<CR>", "Close all other windows" },
    },
    ["<tab>"] = {
      name = "Tabs",
      e = { "<cmd>tablast<CR>", "[T]ab [E]nd" },
      b = { "<cmd>tabfirst<CR>", "[T]ab [B]egin" },
      ["<tab>"] = { "<cmd>tabnew<CR>", "[T]ab new" },
      d = { "<cmd>tabclose<CR>", "[T]ab [D]elete" },
      n = { "<cmd>tabnext<CR>", "[T]ab [N]ext" },
      p = { "<cmd>tabprevious<CR>", "[T]ab [P]revious" },
    },
    ["?"] = { "Cheatsheet" },
    x = {
      name = "Diagnostics",
      x = { "Document diagnostics" },
      X = { "Workspace diagnostics" },
      L = { "Location list" },
      Q = { "Quickfix list" },
    },
    c = {
      name = "Comments",
      ["<C-/>"] = { "<Plug>(comment_toggle_linewise_current)", "Comment line" },
      b = { "<cmd>CBccbox<CR>", "Box title comment" },
      t = { "<cmd>CBllline6<CR>", "Title line comment" },
      l = { "<cmd>CBline<CR>", "Separator comment" },
      s = { "<cmd>CBllbox12<CR>", "Section comment" },
    },
    l = {
      name = "LSP",
      a = { vim.lsp.buf.code_action, "Code action", { noremap = false } },
      D = { vim.lsp.buf.declaration, "Go to declaration" },
      d = { vim.lsp.buf.definition, "Go to definition" },
      i = { vim.lsp.buf.implementation, "Go to implementation" },
      h = { vim.lsp.buf.signature_help, "Show signature help" },
      t = { vim.lsp.buf.type_definition, "Go to type definition" },
      r = { vim.lsp.buf.references, "Show references" },
    },
    ["+"] = {
      function()
        require("dial.map").manipulate("increment", "normal")
      end,
      "Increment",
    },
    ["-"] = {
      function()
        require("dial.map").manipulate("decrement", "normal")
      end,
      "Decrement",
    },
    ["~"] = {
      name = "Text manipulation",
      UU = { "gUU", "Uppercase line" },
      uu = { "guu", "Lowercase line" },
      ["~"] = { "V~", "Toggle case in line" },
      a = { "Align" },
      s = {
        name = "Sort",
        ["'"] = { "vi'<cmd>Sort i<CR><esc>", "Sort in ' '" },
        ["`"] = { "vi`<cmd>Sort i<CR><esc>", "Sort in ` `" },
        ['"'] = { 'vi"<cmd>Sort i<CR><esc>', 'Sort in " "' },
        ["("] = { "vi(<cmd>Sort i<CR><esc>", "Sort in ( )" },
        ["["] = { "vi[<cmd>Sort i<CR><esc>", "Sort in [ ]" },
        ["{"] = { "vi{<cmd>Sort i<CR><esc>", "Sort in { }" },
        ["<"] = { "vi<<cmd>Sort i<CR><esc>", "Sort in < >" },
        p = { "vip<cmd>Sort i<CR><esc>", "Sort in paragraph" },
        b = { "vib<cmd>Sort i<CR><esc>", "Sort in ( )" },
        B = { "viB<cmd>Sort i<CR><esc>", "Sort in { }" },
        s = { "V<cmd>Sort i<CR><esc>", "Sort line" },
      },
    },
    h = {
      name = "Harpoon",
      a = {
        function()
          harpoon:list():add()
        end,
        "Add",
      },
      l = {
        function()
          toggle_telescope(harpoon:list())
        end,
        "View list",
      },
      n = {
        function()
          harpoon:list():next()
        end,
        "Next",
      },
      p = {
        function()
          harpoon:list():prev()
        end,
        "Previous",
      },
      d = {
        function()
          harpoon:list():remove()
        end,
        "Delete",
      },
    },
  },
  ["++"] = {
    function()
      require("dial.map").manipulate("increment", "normal")
    end,
    "Increment",
  },
  ["--"] = {
    function()
      require("dial.map").manipulate("decrement", "normal")
    end,
    "Decrement",
  },
}, { mode = "n" })

-- VISUAL
wk.register({
  ["<leader>"] = {
    c = {
      name = "Comments",
      ["<C-/>"] = { "<Plug>(comment_toggle_linewise_current)", "Comment line" },
      b = { "<cmd>CBccbox<CR>", "Box title comment" },
      t = { "<cmd>CBllline6<CR>", "Title line comment" },
      l = { "<cmd>CBline<CR>", "Separator comment" },
      s = { "<cmd>CBllbox12<CR>", "Section comment" },
    },
    ["+"] = {
      function()
        require("dial.map").manipulate("increment", "visual")
      end,
      "Increment",
    },
    ["-"] = {
      function()
        require("dial.map").manipulate("decrement", "visual")
      end,
      "Decrement",
    },
    ["~"] = {
      name = "Text manilation",
      s = { "<cmd>Sort<CR>", "Sort" },
    },
    s = {
      r = { "<cmd>SearchReplaceVisualSelection<CR>", "Replace selection" },
    },
  },
  ["++"] = {
    function()
      require("dial.map").manipulate("increment", "normal")
    end,
    "Increment",
  },
  ["--"] = {
    function()
      require("dial.map").manipulate("decrement", "normal")
    end,
    "Decrement",
  },
}, { mode = "v", noremap = false })
