local uv = vim.loop
local M = {}

-- TODO timer should be able to specify a message?!
-- dict of 'time_in_seconds -> {t = timer, name = nil or string, unit = string of one of the suffixes in parsing.lua }'
_TIMERS = {}

-- returns a tuple of the timer and the time the timer was
-- created in unix format in seconds
function M.new_timer(name, unit)
  local timer = uv.new_timer()
  local timestamp = uv.gettimeofday()
  local tab = { t = timer }
  if name ~= nil then
    tab.name = name
  end
  if unit ~= nil then
    tab.unit = unit
  end
  _TIMERS[timestamp] = tab
  return timer, timestamp
end

-- ends the timer and removes it from the timer registry
function M.end_timer(timestamp)
  local o_timestamp = vim.deepcopy(timestamp)
  if type(timestamp) == "string" then
    for stamp, tab in pairs(_TIMERS) do
      if tab.name == timestamp then
        timestamp = stamp
        break
      end
    end
  end
  timestamp = tonumber(timestamp)
  local ref = _TIMERS[timestamp]
  if timestamp == nil or not ref then
    -- TODO LOGGING
    vim.print("Key for timer not found: " .. o_timestamp)
  else
    local timer = ref.t
    _TIMERS[timestamp] = nil
    timer:stop()
    timer:close()
  end
end

-- returns the time in seconds the timer is still running
-- TODO it would be better if the plugin could show the localized time
local function due(timer)
  return uv.timer_get_due_in(timer) / 1000
end

-- TODO accept a name / id for a timer and show due time then
function M.tbl_of_timers()
  local tab = {}
  for stamp, value in pairs(_TIMERS) do
    local due_v = due(value.t)
    local due_time = string.format("Due in %0.f seconds", due_v)
    tab[stamp] = { due = due_time, due_raw = due_v }
    if value.name then
      table.insert(tab[stamp], 1, value.name)
    end
    if value.unit then
      tab[stamp].unit = value.unit
    end
  end
  return tab
end

function M.end_all()
  for key, _ in pairs(_TIMERS) do
    M.end_timer(key)
  end
end

return M
