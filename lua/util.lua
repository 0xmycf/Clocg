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

return M
