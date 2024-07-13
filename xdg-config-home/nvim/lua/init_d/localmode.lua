local M = {}
local augroup = vim.api.nvim_create_augroup("AweLocalMode", {})

local sessions = require("sessions.vars")
sessions.register_win_vars({ "local_mode" })

local function restore_mode()
    local to_mode = vim.w.local_mode
    vim.w.local_mode = nil
    if to_mode == nil then
        return
    end

    if to_mode == "t" then
        vim.cmd.startinsert()
    elseif to_mode == "v" then
        vim.cmd.normal("gv")
    elseif to_mode == "i" then
        if vim.fn.col(".") == vim.fn.col("$") - 1 then
            vim.cmd("startinsert!")
        else
            vim.cmd.normal("l")
            vim.cmd.startinsert()
        end
    end
end

function M.execute_move(from_mode, mover)
    vim.w.local_mode = from_mode
    vim.cmd.stopinsert()
    vim.schedule(mover)
end

vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    callback = function()
        vim.schedule(function()
            restore_mode()
        end)
    end,
})

return M
