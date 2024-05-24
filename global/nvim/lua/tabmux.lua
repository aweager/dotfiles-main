local M = {}
local augroup = vim.api.nvim_create_augroup("AweTabMux", {})

vim.api.nvim_create_autocmd("TabLeave", {
    group = augroup,
    callback = function()
        vim.g.last_tab = vim.api.nvim_get_current_tabpage()
    end,
})

vim.g.num_pinned_tabs = 0
vim.g.last_tab = 1

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

return M
