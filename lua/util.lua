local pop = require("plenary.popup")
local M = {}

-- deferred until the event loop has time to deal with this again
M.mk_popup = vim.schedule_wrap(function(text)
  local _, win = pop.create(text, {
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    highlight = "ClocgWindow"
  })
  vim.api.nvim_win_set_option(
    win.border.win_id,
    "winhl",
    "Normal:ClogcBorder"
  )
end)

-- tail of a list
function M.tail(args)
  local tab = {}
  for i = 2, #args do
    table.insert(tab, args[i])
  end
  return tab
end

-- reduce :: Table a -> (a -> b -> Int -> b) -> b -> b
function M.reduce(list, fn, acc)
  for i = 1, #list do
    acc = fn(list[i], acc, i)
  end
  return acc
end

-- bad name: works on the full list not on the tail
-- returns nil if the rest of the args concat to ""
function M.tail_to_string(list)
  local tail = M.tail(list)
  local name = M.reduce(tail,
    function(v, acc, i)
      if i == #tail then
        return acc .. tostring(v)
      end
      return acc .. tostring(v) .. " "
    end, "")
  if name == "" then name = nil end
  return name
end

return M
