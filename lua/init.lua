local P = require("plenary.path")
local M = {}

local cachePath = P:new(vim.fn.stdpath("cache"), "clocg")

vim.print(cachePath.filename)

if not cachePath:is_dir() then
  -- TODO add log message
  cachePath:mkdir()
end

-- local test_fun = function()
--   -- TODO add log message
--   P:new(cachePath .. "/config.json"):write(vim.json.encode("{\"foo\": 132}"), "w")
-- end

-- give a time in minutes, after those minutes the plugin will display a text-message (popup)
-- telling you that your time is over
--
-- This needs to be done asynchronously 
-- 
-- Questions which need to be answered:
--  1. What if nvim gets closed and reopened in the meantime? -> We need to safe this to a config somewhere somehow
--                                                               How / What data would we store and how would we deal with that data
vim.api.nvim_create_user_command('ClogcTill', function(args)
  vim.print("called with arg: " .. tostring(args.fargs[1]))
  -- https://neovim.io/doc/user/map.html#%3Acommand-nargs
end, { nargs = 1 })

return M
