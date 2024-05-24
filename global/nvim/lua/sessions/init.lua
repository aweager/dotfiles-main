-- Only proceed if there is a session file
if vim.env.NVIM_SESSION_FILE == nil then
    return {}
end

local M = {}
local augroup = vim.api.nvim_create_augroup("AweSessions", {})

vim.g.session_file = vim.env.NVIM_SESSION_FILE
vim.o.sessionoptions = "blank,buffers,help,tabpages,winsize,terminal"

local saved_vars = {
    old_bufid_by_name = {},
    global = {
        vars = {},
    },
    tab = {},
    buffer = {},
}
local loaded_vars = {
    old_bufid_by_name = {},
    bufid_by_old_id = {},
    global = {
        vars = {},
    },
    tab = {},
    buffer = {},
}
local registered_vars = {
    global = {},
    tab = {},
    window = {},
    buffer = {},
}

local function serialize(o)
    if type(o) == "number" then
        return o
    elseif type(o) == "nil" then
        return "nil"
    elseif type(o) == "boolean" then
        return o and "true" or "false"
    elseif type(o) == "string" then
        return string.format("%q", o)
    elseif type(o) == "table" then
        local table_str = "{"
        for key, value in pairs(o) do
            table_str = table_str .. "[" .. serialize(key) .. "]=" .. serialize(value) .. ","
        end
        table_str = table_str .. "}"
        return table_str
    else
        error("Cannot serialize a " .. type(o))
    end
end

local function copy_values(source, dest, keys)
    for _, key in pairs(keys) do
        if source[key] ~= nil then
            dest[key] = source[key]
        end
    end
end

local function save_registered_vars()
    copy_values(vim.g, M.to_save.global(), registered_vars.global)

    for _, tabpage in pairs(vim.api.nvim_list_tabpages()) do
        copy_values(vim.t[tabpage], M.to_save.tab(tabpage), registered_vars.tab)
    end

    for _, window in pairs(vim.api.nvim_list_wins()) do
        copy_values(vim.w[window], M.to_save.win(window), registered_vars.window)
    end

    for _, buffer in pairs(vim.api.nvim_list_bufs()) do
        copy_values(vim.b[buffer], M.to_save.buf(buffer), registered_vars.buffer)
    end
end

local function save_mappings()
    for _, buffer in pairs(vim.api.nvim_list_bufs()) do
        saved_vars.old_bufid_by_name[vim.api.nvim_buf_get_name(buffer)] = buffer
    end
end

vim.api.nvim_create_autocmd("VimLeave", {
    group = augroup,
    callback = function()
        save_registered_vars()
        save_mappings()
        vim.cmd.doautocmd("User", "AweSessionWritePre")
        vim.g.AWESAVEDVARS = serialize(saved_vars)
        vim.cmd.wshada()
        vim.cmd("mksession! " .. vim.g.session_file)
    end,
})

vim.cmd.rshada()
if vim.g.AWESAVEDVARS ~= nil then
    loaded_vars = load("return " .. vim.g.AWESAVEDVARS)()
end

vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = augroup,
    callback = function()
        loaded_vars.old_bufid_by_name = loaded_vars.old_bufid_by_name or {}
        loaded_vars.bufid_by_old_id = {}

        copy_values(M.loaded.global(), vim.g, registered_vars.global)

        for _, tabpage in pairs(vim.api.nvim_list_tabpages()) do
            copy_values(M.loaded.tab(tabpage), vim.t[tabpage], registered_vars.tab)
        end

        for _, window in pairs(vim.api.nvim_list_wins()) do
            copy_values(M.loaded.win(window), vim.w[window], registered_vars.window)
        end

        for _, buffer in pairs(vim.api.nvim_list_bufs()) do
            local old_bufid = loaded_vars.old_bufid_by_name[vim.api.nvim_buf_get_name(buffer)]
            if old_bufid then
                loaded_vars.bufid_by_old_id[old_bufid] = buffer
            end

            copy_values(M.loaded.buf(buffer), vim.b[buffer], registered_vars.buffer)
        end

        vim.cmd.doautocmd("User", "AweSessionLoadPost")
    end,
})

local function empty_tab()
    return {
        vars = {},
        win = {},
    }
end
local function init_tab(dict, tabpage)
    local tabnr = vim.api.nvim_tabpage_get_number(tabpage)
    if dict.tab[tabnr] == nil then
        dict.tab[tabnr] = empty_tab()
    end
    return dict.tab[tabnr]
end

local function empty_win()
    return {
        vars = {},
    }
end
local function init_win(dict, window)
    local tabpage = vim.api.nvim_win_get_tabpage(window)
    local winnr = vim.api.nvim_win_get_number(window)
    local tab = init_tab(dict, tabpage)
    if tab.win[winnr] == nil then
        tab.win[winnr] = empty_win()
    end
    return tab.win[winnr]
end

local function empty_buf()
    return {
        vars = {},
    }
end
local function init_buf(dict, buffer)
    local buftype = vim.bo[buffer].buftype

    if buftype == "" then
        local bufname = vim.api.nvim_buf_get_name(buffer)
        if dict.buffer[bufname] == nil then
            dict.buffer[bufname] = empty_buf()
        end
        return dict.buffer[bufname]
    elseif buftype == "terminal" then
        local term_window = require("terminal").get_terminal_window(buffer)
        if term_window == nil then
            -- silently fail if the terminal isn't in a window
            return empty_buf()
        end

        local window = init_win(dict, term_window)
        if window.term == nil then
            window.term = empty_buf()
        end
        return window.term
    else
        -- silently fail on other buffer types
        return empty_buf()
    end
end

local function make_settings_holder(dict)
    local ret = {}
    function ret.global()
        return dict.global
    end
    function ret.tab(tabpage)
        return init_tab(dict, tabpage)
    end
    function ret.win(window)
        return init_win(dict, window)
    end
    function ret.buf(buffer)
        return init_buf(dict, buffer)
    end
    return ret
end

M.to_save = make_settings_holder(saved_vars)
M.loaded = make_settings_holder(loaded_vars)

function M.register_global_vars(varnames)
    for _, varname in pairs(varnames) do
        table.insert(registered_vars.global, varname)
    end
end

function M.register_tab_vars(varnames)
    for _, varname in pairs(varnames) do
        table.insert(registered_vars.tab, varname)
    end
end

function M.register_win_vars(varnames)
    for _, varname in pairs(varnames) do
        table.insert(registered_vars.window, varname)
    end
end

function M.register_buf_vars(varnames)
    for _, varname in pairs(varnames) do
        table.insert(registered_vars.buffer, varname)
    end
end

function M.find_new_bufid(old_bufid)
    return loaded_vars.bufid_by_old_id[old_bufid] or -1
end

return M
