local P = require("plenary.path")
local util = require("util")
local t = require("timers")
local M = {}

local cachePath = P:new(vim.fn.stdpath("cache"), "clocg")

-- TODO add log message
if not cachePath:is_dir() then
  cachePath:mkdir()
end

-- TODO add log message
function M.something(args)
  local str = args.fargs[1] -- TODO: needs parsing
  local timer, timestamp = t.new_timer()
  timer:start(str * 1000, 0, function()
    util.mk_popup("Time's up!")
    t.end_timer(timestamp)
  end)
end

return M
