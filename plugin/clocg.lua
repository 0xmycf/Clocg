local c = require("init")

vim.api.nvim_create_user_command('ClogcTill', c.till, { nargs = '+' })
vim.api.nvim_create_user_command('ClogcShow', c.show, { nargs = 0 })
