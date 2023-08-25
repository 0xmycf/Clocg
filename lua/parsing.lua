local M = {}

-- returns true and the match if a match was found, false otherwise
-- accepts a table or varaidic number of arguments after the string that should
-- be checked for a match
-- the given matches should be sorted by length otherwise they might return too early
--
-- TODO changes this so that it returns all matches
local match_many = function(str, ...)
  local args
  if type(...) == "table" then
    args = ...
  else
    args = { ... }
  end
  for _, match in ipairs(args) do
    local res = str:match(match)
    if res ~= nil then
      return true, res
    end
  end
  return false
end

local minute_matches = { "minute", "min", "m" }
local second_matches = { "second", "sec", "s" }
local hour_matches = { "hour", "h" }

-- given a string of the format '<time><[m|min|minute]|[s|sec|second]|[h|hour]>'
-- this function returns the time in milliseconds, if no match was found it assumes the string is the number in minutes
M.parse = function(str)
  for factor, tab in pairs { [60000] = minute_matches, [1000] = second_matches, [3600000] = hour_matches } do
    local matched, match = match_many(str, tab)
    if matched then
      local tmp = str:gsub(match, "")
      return factor * tonumber(tmp), match
    end
  end
  return tonumber(str) * 60000, nil
end

return M
