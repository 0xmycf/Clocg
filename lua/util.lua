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

return M
