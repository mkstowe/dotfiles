return {
  "monaqa/dial.nvim",
  lazy = false,
  opts = function()
    local augend = require "dial.augend"

    local logical_alias = augend.constant.new {
      elements = { "&&", "||" },
      word = false,
      cyclic = true,
    }

    local ordinal_numbers = augend.constant.new {
      elements = {
        "first",
        "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eighth",
        "ninth",
        "tenth",
      },
      word = false,
      cyclic = true,
    }

    local number_words = augend.constant.new {
      elements = {
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine",
        "ten",
      },
      word = true,
      cyclic = true,
    }

    local weekdays = augend.constant.new {
      elements = {
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      },
      word = true,
      cyclic = true,
    }

    local weekdays_lower = augend.constant.new {
      elements = {
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
      },
      word = true,
      cyclic = true,
    }

    local weekdays_abbr = augend.constant.new {
      elements = {
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
        "Sun",
      },
      word = true,
      cyclic = true,
    }

    local weekdays_abbr_lower = augend.constant.new {
      elements = {
        "mon",
        "tue",
        "wed",
        "thu",
        "fri",
        "sat",
        "sun",
      },
      word = true,
      cyclic = true,
    }

    local months = augend.constant.new {
      elements = {
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      },
      word = true,
      cyclic = true,
    }

    local months_lower = augend.constant.new {
      elements = {
        "january",
        "february",
        "march",
        "april",
        "may",
        "june",
        "july",
        "august",
        "september",
        "october",
        "november",
        "december",
      },
      word = true,
      cyclic = true,
    }

    local months_abbr = augend.constant.new {
      elements = {
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      },
      word = true,
      cyclic = true,
    }

    local months_abbr_lower = augend.constant.new {
      elements = {
        "jan",
        "feb",
        "mar",
        "apr",
        "may",
        "jun",
        "jul",
        "aug",
        "sep",
        "oct",
        "nov",
        "dec",
      },
      word = true,
      cyclic = true,
    }

    local capitalized_boolean = augend.constant.new {
      elements = {
        "True",
        "False",
      },
      word = true,
      cyclic = true,
    }

    return {
      dials_by_ft = {
        css = "css",
        javascript = "typescript",
        javascriptreact = "typescript",
        json = "json",
        lua = "lua",
        markdown = "markdown",
        python = "python",
        sass = "css",
        scss = "css",
        typescript = "typescript",
        typescriptreact = "typescript",
      },
      groups = {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.hexcolor.new { case = "lower" },
          augend.hexcolor.new { case = "upper" },
          augend.integer.alias.binary,
          ordinal_numbers,
          number_words,

          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%m/%d/%Y"],
          augend.date.alias["%d/%m/%Y"],
          augend.date.alias["%m/%d/%y"],
          augend.date.alias["%d/%m/%y"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%-m/%-d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%H:%M:%S"],
          augend.date.alias["%H:%M"],
          weekdays,
          weekdays_lower,
          weekdays_abbr,
          weekdays_abbr_lower,
          months,
          months_lower,
          months_abbr,
          months_abbr_lower,

          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,

          augend.constant.alias.bool,
          augend.constant.new { elements = { "let", "const" } },
          augend.constant.new {
            elements = { "and", "or" },
            word = true,
            cyclic = true,
          },
          capitalized_boolean,
          logical_alias,

          augend.semver.alias.semver, -- versioning (v1.1.2)
        },
      },
    }
  end,
  config = function(_, opts)
    require("dial.config").augends:register_group(opts.groups)
  end,
}

