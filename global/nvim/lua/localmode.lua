-- vim:foldmethod=marker

-- save mode to be used when returning to this window {{{
local save_mode = function(mode)
    if vim.w.local_mode ~= nil then
        return
    end

    vim.w.local_mode = mode or vim.api.nvim_get_mode().mode
end -- }}}

local restore_mode = function() -- {{{
    local mode = vim.w.local_mode or "n"
    vim.w.local_mode = nil

    -- guard against buffer mismatch
    -- awkward hack for fzf windows causing problems
    if mode == "t" and vim.bo.buftype ~= "terminal" then
        mode = "n"
    end

    local currMode = vim.api.nvim_get_mode().mode
    if currMode == mode then
        return
    end

    if currMode == "i" then
        if mode == "t" then
            -- force out of insert mode and into terminal mode
            vim.cmd.stopinsert()
            vim.cmd.startinsert()
        elseif mode == "v" then
            vim.cmd.stopinsert()
            vim.cmd.normal("gv")
        else
            -- default to normal mode
            vim.cmd.stopinsert()
            vim.cmd.normal("l")
        end
    elseif currMode == "t" then
        if mode == "i" then
            -- force out of terminal mode and into insert mode
            vim.cmd.stopinsert()
            vim.cmd.startinsert()
            vim.cmd.normal("l")
        elseif mode == "v" then
            vim.cmd.stopinsert()
            vim.cmd.normal("gv")
        else
            -- default to normal mode
            vim.cmd.stopinsert()
        end
    else
        if mode == "i" then
            if vim.fn.col(".") == vim.fn.col("$") - 1 then
                vim.cmd("startinsert!")
            else
                vim.cmd.startinsert()
            end
        elseif mode == "t" then
            vim.cmd.startinsert()
        elseif mode == "v" then
            vim.cmd.normal("gv")
        else
            -- default to normal mode
            vim.cmd.stopinsert()
        end
    end
end -- }}}

-- autocmds work for everything except visual mode {{{

local augroup = vim.api.nvim_create_augroup("AweWindowLocalMode", {})

vim.api.nvim_create_autocmd("WinLeave", {
    group = augroup,
    callback = function(ev)
        save_mode()
    end,
})

vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    callback = restore_mode,
})

-- }}}

return {
    save_mode = save_mode,
}
