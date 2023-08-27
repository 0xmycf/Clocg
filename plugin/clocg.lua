local c = require("init")

vim.api.nvim_create_user_command('ClogcTill', c.till, { nargs = '+' })
vim.api.nvim_create_user_command('ClogcShow', c.show, { nargs = 0 })
vim.api.nvim_create_user_command('ClogcStop', c.stop, { nargs = '+' })
vim.api.nvim_create_user_command('ClogcStopAll', c.stop_all, { nargs = 0 })

-- pausing and resuming
vim.api.nvim_create_user_command('ClogcPause', c.pause, { nargs = 1 })
vim.api.nvim_create_user_command('ClogcResume', c.resume, { nargs = 1 })
