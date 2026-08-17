return function()
  require("nvim-treesitter-textobjects").setup {
    select = {
      lookahead = true,
      selection_modes = {
        ["@function.outer"] = "V",
        ["@class.outer"] = "V"
      },
      include_surrounding_whitespace = false,
    },

    move = {
      set_jumps = true,
    },
  }

  local select = require "nvim-treesitter-textobjects.select"
  local move = require "nvim-treesitter-textobjects.move"

  --
  -- Text Objects
  --

  local textobjects = {
    -- Functions
    ["if"] = "@function.inner",
    ["af"] = "@function.outer",

    -- Classes
    ["ic"] = "@class.inner",
    ["ac"] = "@class.outer",

    -- Conditionals
    ["ii"] = "@conditional.inner",
    ["ai"] = "@conditional.outer",

    -- Loops
    ["il"] = "@loop.inner",
    ["al"] = "@loop.outer",

    -- Parameters / arguments
    ["ia"] = "@parameter.inner",
    ["aa"] = "@parameter.outer",
  }

  for key, query in pairs(textobjects) do
    vim.keymap.set({ "x", "o" }, key, function()
      select.select_textobject(query, "textobjects")
    end, {
        desc = "Treesitter " .. query,
      }
  )
  end

  -- 
  -- Movement
  --
  vim.keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer", "textobjects")
  end, {
      desc = "Next function"
    }
  )

  vim.keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end, {
      desc = "Previous function",
    }
  )

  vim.keymap.set({ "n", "x", "o" }, "]]", function()
    move.goto_next_start("@class.outer", "textobjects")
  end, {
      desc = "Next class"
    }
  )

  vim.keymap.set({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start("@class.outer", "textobjects")
  end, {
      desc = "Previous class"
    }
  )
end
