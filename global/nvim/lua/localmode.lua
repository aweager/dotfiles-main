local M = {}
local augroup = vim.api.nvim_create_augroup("AweWindowLocalMode", {})

local sessions = require("sessions")
sessions.register_win_vars({ "local_mode" })

function M.save_mode(mode)
    if vim.w.local_mode ~= nil then
        return
    end

    vim.w.local_mode = mode or vim.api.nvim_get_mode().mode
end

local dest_mode = nil
local function restore_mode()
    if dest_mode == nil then
        return
    end

    local currMode = vim.api.nvim_get_mode().mode
    if currMode == dest_mode then
        vim.print("Already in dest mode " .. dest_mode)
        dest_mode = nil
        return
    end

    if currMode ~= "n" and currMode ~= "nt" then
        vim.print("Waiting for normal mode")
        return
    end

    vim.print("Restoring mode " .. dest_mode)

    if dest_mode == "t" then
        vim.api.nvim_input("i")
    elseif dest_mode == "v" then
        vim.cmd.normal("gv")
    elseif dest_mode == "i" then
        if vim.fn.col(".") == vim.fn.col("$") - 1 then
            vim.api.nvim_input("A")
        else
            vim.api.nvim_input("i")
        end
        -- elseif currMode == "i" then
        --     vim.cmd.normal("l")
    end

    dest_mode = nil
end

local function enqueue_restore_mode()
    local mode = vim.w.local_mode
    vim.w.local_mode = nil

    if mode == nil then
        return
    end

    vim.print("Enqueuing restore mode " .. mode)

    local buftype = vim.bo.buftype

    -- guard against buffer mismatch
    -- awkward hack for fzf windows causing problems
    if mode == "t" and buftype ~= "terminal" then
        mode = "n"
    end

    local currMode = vim.api.nvim_get_mode().mode
    if currMode == mode then
        return
    end

    dest_mode = mode
    if currMode == "n" or currMode == "nt" then
        restore_mode()
    else
        vim.cmd.stopinsert()
    end
end

vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
        vim.print("Mode changed: " .. vim.v.event.old_mode .. " -> " .. vim.v.event.new_mode)
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    group = augroup,
    callback = function()
        -- this works for everything except visual mode
        M.save_mode()
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = enqueue_restore_mode,
})

vim.api.nvim_create_autocmd("ModeChanged", {
    group = augroup,
    callback = restore_mode,
})

function M.execute_move(mode, mover)
    if vim.w.local_mode ~= nil then
        return
    end
    vim.w.local_mode = mode

    vim.cmd.stopinsert()
    mover()
    restore_mode()
end

return M
