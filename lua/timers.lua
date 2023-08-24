local uv = vim.loop
local M = {}

-- dict of 'time_in_seconds -> {t = timer, name = nil or string}'
_TIMERS = {}

-- returns a tuple of the timer and the time the timer was
-- created in unix format in seconds
function M.new_timer(name)
  local timer = uv.new_timer()
  local timestamp = uv.gettimeofday()
  local tab = { t = timer }
  if name ~= nil then
    tab = vim.tbl_deep_extend("keep", tab, { name = name })
  end
  _TIMERS[timestamp] = tab
  return timer, timestamp
end

-- ends the timer and removes it from the timer registry
function M.end_timer(timestamp)
  if type(timestamp) == "string" then
    for stamp, tab in pairs(_TIMERS) do
      if tab.name == timestamp then
        timestamp = stamp
        break
      end
    end
  end
  local timer = _TIMERS[timestamp].t
  _TIMERS[timestamp] = nil
  timer:stop()
  timer:close()
end

-- returns the time in seconds the timer is still running
-- TODO it would be better if the plugin could show the localized time
local function due(timer)
  return uv.timer_get_due_in(timer) / 1000
end

-- TODO accept a name / id for a timer and show due time then
function M.all_timers()
  local tab = {}
  for stamp, value in pairs(_TIMERS) do
    if value.name then
      tab[stamp] = { value.name, due = due(value.t) }
    else
      tab[stamp] = { due = due(value.t) }
    end
  end
  return tab
end

return M
