local M = {}
local utils = require('possession.utils')
local session = require('possession.session')
local storage_data = {}

local function get_buf_name_list()
    return vim.tbl_map(vim.api.nvim_buf_get_name, vim.api.nvim_list_bufs())
end

local function close_other_buffers()
    if storage_data.buf_list == nil then
        return storage_data
    end

    local buf_set = utils.list_to_set(storage_data.buf_list)

    for _, handle in pairs(vim.api.nvim_list_bufs()) do
        if
          buf_set[vim.api.nvim_buf_get_name(handle)] == nil
          and 'notify' ~= vim.api.nvim_buf_get_option(handle, 'filetype')
        then
            vim.api.nvim_buf_delete(handle, { force = true })
        end
    end
    return storage_data
end

function M.before_save(_, _)
    if session.save_way == 'autosave' then
        return close_other_buffers()
    end

    storage_data.buf_list = get_buf_name_list()
    return storage_data
end

function M.after_load(_, _, _)
    storage_data.buf_list = get_buf_name_list()
end

return M
