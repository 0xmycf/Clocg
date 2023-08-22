local c = require("init")

--                                                    fargs[1]
vim.api.nvim_create_user_command('ClogcTill', c.something, { nargs = 1 }) -- https://neovim.io/doc/user/map.html#%3Acommand-nargs
