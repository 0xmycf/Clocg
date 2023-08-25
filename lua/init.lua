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
  local num, unit = parse.parse(args.fargs[1])
  local name = util.tail_to_string(args.fargs)
  local timer, timestamp = t.new_timer(name, unit)
  timer:start(num, 0, function()
    util.mk_popup("Time's up!")
    t.end_timer(timestamp)
  end)
end

function M.show(_)
  vim.print(vim.inspect(t.tbl_of_timers()))
end

function M.stop(args)
  local stamp = args.fargs[1]
  local name = util.tail_to_string(args.fargs)
  if not name then
    t.end_timer(stamp)
  else
    t.end_timer(stamp .. " " .. name)
  end
end

function M.stop_all(_)
  t.end_all()
end

return M
