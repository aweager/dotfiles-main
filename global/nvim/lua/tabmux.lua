vim.g.num_pinned_tabs = 0

local M = {}

function M.toggle_pin()
    local tab_mux_vars = vim.t.mux or {}
    if tab_mux_vars.pinned then
        vim.cmd.tabmove(vim.g.num_pinned_tabs)
        vim.g.num_pinned_tabs = vim.g.num_pinned_tabs - 1
        tab_mux_vars.pinned = nil
    else
        vim.cmd.tabmove(vim.g.num_pinned_tabs)
        vim.g.num_pinned_tabs = vim.g.num_pinned_tabs + 1
        tab_mux_vars.pinned = true
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

return M
