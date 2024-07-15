local M = {}
local augroup = vim.api.nvim_create_augroup("AweTabMux", {})

vim.g.num_pinned_tabs = 0
vim.g.last_tab = 1

local sessions = require("sessions.vars")
sessions.register_tab_vars({ "is_pinned" })
sessions.register_global_vars({ "num_pinned_tabs", "last_tab" })

function M.toggle_pin()
    if vim.t.is_pinned then
        vim.t.is_pinned = nil
        vim.cmd.tabmove(vim.g.num_pinned_tabs)
        vim.g.num_pinned_tabs = vim.g.num_pinned_tabs - 1
    else
        vim.t.is_pinned = true
        vim.cmd.tabmove(vim.g.num_pinned_tabs)
        vim.g.num_pinned_tabs = vim.g.num_pinned_tabs + 1
    end
    vim.cmd.redrawtabline()
end

function M.move_left()
    local tabs = vim.api.nvim_list_tabpages()

    if vim.t.is_pinned then
        if vim.api.nvim_get_current_tabpage() == tabs[1] then
            vim.print("Reached far left of pinned tab group")
        else
            vim.cmd.tabmove("-1")
        end
    else
        if vim.api.nvim_get_current_tabpage() == tabs[vim.g.num_pinned_tabs + 1] then
            vim.cmd.tabmove()
        else
            vim.cmd.tabmove("-1")
        end
    end
    vim.cmd.redrawtabline()
end

function M.move_right()
    local tabs = vim.api.nvim_list_tabpages()

    if vim.t.is_pinned then
        if vim.api.nvim_get_current_tabpage() == tabs[vim.g.num_pinned_tabs] then
            vim.print("Reached far right of pinned tab group")
        else
            vim.cmd.tabmove("+1")
        end
    else
        if vim.api.nvim_get_current_tabpage() == tabs[#tabs] then
            vim.cmd.tabmove(vim.g.num_pinned_tabs)
        else
            vim.cmd.tabmove("+1")
        end
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

        if vim.t[tabpage].is_pinned then
            vim.g.num_pinned_tabs = vim.g.num_pinned_tabs - 1
        end
        vim.cmd.tabclose(tabnr)
    end
end

vim.api.nvim_create_autocmd("TabLeave", {
    group = augroup,
    callback = function()
        vim.g.last_tab = vim.api.nvim_get_current_tabpage()
    end,
})

return M
