local M = {}
local augroup = vim.api.nvim_create_augroup("AweTerminal", {})

vim.keymap.set("t", "<m-C>", "<c-\\><c-n>")
vim.o.scrollback = 100000

local session_loaded = false
local zshrc_hooks = {}
local state_dir = vim.fn.stdpath("state") .. "/terminal_state/" .. vim.fn.getpid()
-- TODO use uv
os.execute("mkdir -p '" .. state_dir .. "'")

function M.get_terminal_window(bufnr)
    for _, window in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(window) == bufnr then
            return window
        end
    end
    return nil
end

local function write_fifo(value, fifo)
    local uv = vim.loop
    uv.fs_open(fifo, "w", tonumber("0644", 8), function(err, fd)
        if err then
            error("Error opening fifo '" .. fifo("' for write: ") .. err)
        end

        fd = assert(fd)
        uv.fs_write(fd, value)
        uv.fs_close(fd)
    end)
end

local function histfile(pid)
    return state_dir .. "/" .. pid .. ".zsh_history"
end

local function default_zshrc_hook_value(pid)
    local init_cmds = {}
    table.insert(init_cmds, "touch '" .. histfile(pid) .. "'")
    table.insert(init_cmds, "export HISTFILE='" .. histfile(pid) .. "'")
    table.insert(init_cmds, "setopt share_history")
    return table.concat(init_cmds, "\n")
end

local function execute_zshrc_hook(hook)
    write_fifo(hook.value, hook.fifo)
end

function M.write_zshrc_hook(pid, fifo)
    local bufnr = require("mux").pid_to_bufnr(pid)
    if not bufnr or bufnr < 0 then
        write_fifo("true", fifo)
        return
    end

    if session_loaded then
        if zshrc_hooks[bufnr] then
            zshrc_hooks[bufnr].fifo = fifo
            execute_zshrc_hook(zshrc_hooks[bufnr])
        else
            execute_zshrc_hook({
                value = default_zshrc_hook_value(pid),
                fifo = fifo,
            })
        end
    else
        -- add hook for after session restore
        zshrc_hooks[bufnr] = {
            fifo = fifo,
        }
    end
end

local function save_terminal(bufnr)
    local sessions = require("sessions")
    local to_save = sessions.to_save.buf(bufnr)
    local uv = vim.loop

    to_save.pid = vim.b[bufnr].terminal_job_pid

    pcall(function()
        local data_dir = vim.fn.stdpath("data") .. "/terminal_data/" .. to_save.pid
        -- TODO use uv
        -- uv.fs_mkdir(data_dir, tonumber("0777", 8))
        os.execute("mkdir -p " .. data_dir)
        to_save.data_dir = data_dir
    end)

    pcall(function()
        local histfile_source = histfile(to_save.pid)
        local histfile_dest = to_save.data_dir .. "/zsh_history"
        if uv.fs_rename(histfile_source, histfile_dest) then
            to_save.history_file = histfile_dest
        end
    end)

    pcall(function()
        local filename = to_save.data_dir .. "/contents.txt"
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.o.scrollback, false)
        local file = assert(uv.fs_open(filename, "w", tonumber("0644", 8)))

        local numBlanks = 0
        for _, line in pairs(lines) do
            if line == "" then
                numBlanks = numBlanks + 1
            else
                for _ = 1, numBlanks do
                    uv.fs_write(file, "\n")
                    numBlanks = 0
                end
                uv.fs_write(file, line .. "\n")
            end
        end
        uv.fs_close(file)
        to_save.contents_file = filename
    end)
end

local function restore_terminal(bufnr)
    local sessions = require("sessions")
    local terminal_data = sessions.loaded.buf(bufnr)

    local new_pid = vim.b[bufnr].terminal_job_pid
    local restore_cmds = {}

    local mux_vars = terminal_data.vars.mux or {}
    if mux_vars.pwd ~= nil then
        table.insert(restore_cmds, 'cd "' .. mux_vars.pwd .. '"')
    end

    if terminal_data.contents_file ~= nil then
        table.insert(restore_cmds, 'cat "' .. terminal_data.contents_file .. '"')
        table.insert(restore_cmds, 'rm "' .. terminal_data.contents_file .. '"')
    end

    if terminal_data.history_file ~= nil then
        table.insert(
            restore_cmds,
            "mv '" .. terminal_data.history_file .. "' '" .. histfile(new_pid) .. "'"
        )
        table.insert(restore_cmds, "export HISTFILE='" .. histfile(new_pid) .. "'")
        table.insert(restore_cmds, "setopt share_history")
    end

    if terminal_data.data_dir ~= nil then
        table.insert(restore_cmds, 'rmdir "' .. terminal_data.data_dir .. '"')
    end

    table.insert(restore_cmds, 'echo "\n -- RESTORED ' .. terminal_data.pid .. '" --')

    local hook_value = table.concat(restore_cmds, "\n")
    if zshrc_hooks[bufnr] then
        zshrc_hooks[bufnr].value = table.concat(restore_cmds, "\n")
        execute_zshrc_hook(zshrc_hooks[bufnr])
    else
        zshrc_hooks[bufnr] = {
            value = hook_value,
        }
    end
end

local function configure_terminal(bufnr)
    vim.keymap.set("n", "<enter>", "i", { buffer = bufnr })
    vim.keymap.set("n", "<c-c>", "i<c-c>", { buffer = bufnr })
    local buffer_augroup = vim.api.nvim_create_augroup("AweTerminalBuf" .. bufnr, {})
    vim.api.nvim_create_autocmd("BufHidden", {
        group = buffer_augroup,
        buffer = bufnr,
        callback = function(ev)
            local to_delete = ev.buf
            vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(to_delete) then
                    vim.api.nvim_buf_delete(to_delete, { force = true })
                end
            end, 100)
            return true
        end,
    })
end

vim.api.nvim_create_autocmd("User", {
    pattern = "AweSessionWritePre",
    group = augroup,
    callback = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == "terminal" then
                save_terminal(buf)
            end
        end
        -- TODO use uv
        os.execute("rmdir " .. state_dir)
    end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = augroup,
    callback = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == "terminal" then
                restore_terminal(buf)
                configure_terminal(buf)
            end
        end
        session_loaded = true
        return true
    end,
})

local function term_enter()
    vim.cmd.NoMatchParen()
    vim.opt.hlsearch = false
    vim.opt_local.number = false
end

local function term_leave()
    vim.cmd.DoMatchParen()
    vim.opt.hlsearch = true
    vim.opt_local.number = true
end

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        configure_terminal(vim.api.nvim_get_current_buf())
        if not vim.g.session_file or session_loaded then
            vim.cmd.startinsert()
            term_enter()
        end
    end,
})

vim.api.nvim_create_autocmd("TermEnter", {
    group = augroup,
    callback = term_enter,
})

vim.api.nvim_create_autocmd("TermLeave", {
    group = augroup,
    callback = term_leave,
})

return M
