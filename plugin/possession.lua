local config = require('possession.config')
local session = require('possession.session')
local possession_group = vim.api.nvim_create_augroup('Possession', {})

vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = possession_group,
    callback = function()
        if config.autosave.on_quit then
            session.autosave()
        end
    end,
})
