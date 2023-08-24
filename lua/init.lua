local P = require("plenary.path")
local util = require("util")
local t = require("timers")
local parse = require("parsing")
local M = {}

local cachePath = P:new(vim.fn.stdpath("cache"), "clocg")

-- TODO add log message
if not cachePath:is_dir() then
  cachePath:mkdir()
end

-- TODO add log message
function M.till(args)
  vim.print(vim.inspect(args.fargs))
  local num = parse.parse(args.fargs[1])
  local tail = util.tail(args.fargs)
  local name = util.reduce(tail, function(v, acc, i)
    if i == #tail then
      return acc .. tostring(v)
    end
    return acc .. tostring(v) .. " "
  end, "")
  local timer, timestamp = t.new_timer(name)
  timer:start(num, 0, function()
    util.mk_popup("Time's up!")
    t.end_timer(timestamp)
  end)
end

function M.show(_)
  vim.print(vim.inspect(t.all_timers()))
end

return M
