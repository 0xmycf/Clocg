local uv = vim.loop
local M = {}

-- dict of 'time_in_seconds -> timer'
_TIMERS = {}

-- returns a tuple of the timer and the time the timer was
-- created in unix format in seconds
function M.new_timer()
  local timer = uv.new_timer()
  local timestamp = uv.gettimeofday()
  _TIMERS[timestamp] = timer
  return timer, timestamp
end

-- ends the timer and removes it from the timer registry
function M.end_timer(timestamp)
  local timer = _TIMERS[timestamp]
  _TIMERS[timestamp] = nil
  timer:stop()
  timer:close()
end

return M
