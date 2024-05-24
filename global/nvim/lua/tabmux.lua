local M = {}
local augroup = vim.api.nvim_create_augroup("AweTabMux", {})

vim.g.num_pinned_tabs = 0
vim.g.last_tab = 1

local sessions = require("sessions")
sessions.register_tab_vars({ "mux" })
sessions.register_global_vars({ "num_pinned_tabs", "last_tab" })

function M.toggle_pin()
    local tab_mux_vars = M.get_vars()
    if tab_mux_vars.pinned then
        tab_mux_vars.pinned = nil
        vim.cmd.tabmove(vim.g.num_pinned_tabs)
        vim.g.num_pinned_tabs = vim.g.num_pinned_tabs - 1
    else
        tab_mux_vars.pinned = true
        vim.cmd.tabmove(vim.g.num_pinned_tabs)
        vim.g.num_pinned_tabs = vim.g.num_pinned_tabs + 1
    end
    vim.t.mux = tab_mux_vars
    vim.cmd.redrawtabline()
end

function M.move_left()
    local tabs = vim.api.nvim_list_tabpages()
    if vim.api.nvim_get_current_tabpage() == tabs[vim.g.num_pinned_tabs + 1] then
        vim.cmd.tabmove()
    else
        vim.cmd.tabmove("-1")
    end
    vim.cmd.redrawtabline()
end

function M.move_right()
    local tabs = vim.api.nvim_list_tabpages()
    if vim.api.nvim_get_current_tabpage() == tabs[#tabs] then
        vim.cmd.tabmove(vim.g.num_pinned_tabs)
    else
        vim.cmd.tabmove("+1")
    end
    vim.cmd.redrawtabline()
end

function M.close_tab()
    if #vim.api.nvim_list_tabpages() == 1 then
        vim.cmd.quitall()
    else
        local tabpage = vim.api.nvim_get_current_tabpage()
        local tabnr = vim.api.nvim_tabpage_get_number(tabpage)
        if vim.api.nvim_tabpage_is_valid(vim.g.last_tab) then
            local last_tabnr = vim.api.nvim_tabpage_get_number(vim.g.last_tab)
            vim.cmd.tabnext(last_tabnr)
        end
        vim.cmd.tabclose(tabnr)
    end
end

function M.rename_tab(tabpage, new_title)
    local tab_mux_vars = M.get_vars(tabpage)
    tab_mux_vars.title = new_title
    vim.t[tabpage] = tab_mux_vars
end

function M.get_vars(tabpage)
    tabpage = tabpage or vim.api.nvim_get_current_tabpage()
    return vim.t[tabpage].mux or {}
end

vim.api.nvim_create_autocmd("TabLeave", {
    group = augroup,
    callback = function()
        vim.g.last_tab = vim.api.nvim_get_current_tabpage()
    end,
})

return M
