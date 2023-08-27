local uv = vim.loop
local M = {}

--[[
TODO timer should be able to specify a message?!
dict of 'time_in_seconds -> {t = timer, name = nil or string, unit = string of one of the suffixes in parsing.lua }'

type item of _TIMERS {
  time_in_seconds (number): {
    t : timer
    name : nil | string
    unit : string             -- one of the suffixes which get checked in the parsing.lua module
    stopped = nil | number    -- the remaining time in milliseconds
  }
}
]]
_TIMERS = {}

-- returns the timer data as well as the unique to the timer
local function find_timer(name)
  if type(name) == "string" then
    local as_num = tonumber(name)
    if as_num then
      return _TIMERS[as_num].t, as_num
    else
      for stamp, time_data in pairs(_TIMERS) do
        if time_data.name == name then
          return _TIMERS[stamp].t, stamp
        end
      end
      return nil
    end
  else
    return _TIMERS[name].t, name
  end
end

local function timer_not_found(id)
  vim.print("timer with id/name: " .. id .. "couldn't be found")
end

-- returns a tuple of the timer and the time the timer was
-- created in unix format in seconds
function M.new_timer(name, unit)
  local timer = uv.new_timer()
  local timestamp = uv.now()
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

-- this does only stop the timer, but does not delete it from the _TIMERS table
local function stop_timer(timer)
  timer:stop()
  timer:close()
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
    local due_time
    if value.stopped then
      due_time = string.format("Timer is stopped, remaining time: %is", value.stopped / 1000)
    else
      due_time = string.format("Due in %0.f seconds", due_v)
    end
    -- This should probably only be shown in some debug output
    -- tab[stamp] = { due = due_time, due_raw = due_v }
    tab[stamp] = { due = due_time }
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

function M.pause(id)
  local timer, key = find_timer(id)
  if timer == nil then
    timer_not_found(id); return
  end
  local remaining_time_ms = uv.timer_get_due_in(timer)
  _TIMERS[key].stopped = remaining_time_ms
  stop_timer(timer)
  vim.print("stopped timer with id " .. tostring(key))
end

function M.resume(id)
  local timer, key = find_timer(id)
  if timer == nil then
    timer_not_found(id); return
  end
  local timer_data = _TIMERS[key]
  local remaining_time_ms = timer_data.stopped
  local new_timer = uv.new_timer()
  timer_data.stopped = nil
  timer_data.t = new_timer
  new_timer:start(remaining_time_ms, 0, function()
    require("util").mk_popup("Time's up!")
    M.end_timer(key)
  end)
  vim.print("Resumed timer with id " .. tostring(key) .. string.format(" (%is)", remaining_time_ms / 1000))
end

return M
