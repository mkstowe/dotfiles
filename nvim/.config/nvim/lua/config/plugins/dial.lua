return function()
  local augend = require "dial.augend"

  local function constant(elements, word)
    return augend.constant.new {
      elements = elements,
      word = word,
      cyclic = true,
    }
  end

  local function map(values, transform)
    local result = {}
    for index, value in ipairs(values) do
      result[index] = transform(value)
    end
    return result
  end

  local weekdays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }
  local months = {
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
  }

  local function lower(value)
    return value:lower()
  end

  local function abbreviate(value)
    return value:sub(1, 3)
  end

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
        constant(
          { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
          false
        ),
        constant({ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten" }, true),

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
        constant(weekdays, true),
        constant(map(weekdays, lower), true),
        constant(map(weekdays, abbreviate), true),
        constant(map(map(weekdays, abbreviate), lower), true),
        constant(months, true),
        constant(map(months, lower), true),
        constant(map(months, abbreviate), true),
        constant(map(map(months, abbreviate), lower), true),

        augend.constant.alias.alpha,
        augend.constant.alias.Alpha,
        augend.constant.alias.bool,
        constant({ "let", "const" }, false),
        constant({ "and", "or" }, true),
        constant({ "True", "False" }, true),
        constant({ "&&", "||" }, false),
        augend.semver.alias.semver,
      },
    },
  }
end
