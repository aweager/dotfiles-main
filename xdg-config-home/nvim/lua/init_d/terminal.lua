local M = {}
local augroup = vim.api.nvim_create_augroup("AweTerminal", {})

vim.keymap.set("t", "<m-C>", "<c-\\><c-n>")
vim.o.scrollback = 100000

local zshrc_hooks = {}
local state_dir = vim.fn.stdpath("state") .. "/terminal_state/" .. vim.fn.getpid()
-- TODO use uv
os.execute("mkdir -p '" .. state_dir .. "'")

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
    table.insert(init_cmds, "export SAVEHIST=1000")
    table.insert(init_cmds, "export HISTFILE='" .. histfile(pid) .. "'")
    table.insert(init_cmds, "setopt share_history")
    return table.concat(init_cmds, "\n")
end

local function execute_zshrc_hook(hook)
    write_fifo(hook.value, hook.fifo)
end

function M.pid_to_bufnr(pid)
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        if vim.b[buf].terminal_job_pid == pid then
            return buf
        end
    end
    return nil
end

function M.write_zshrc_hook(pid, fifo)
    local bufnr = M.pid_to_bufnr(pid)
    if not bufnr then
        write_fifo("true", fifo)
        return
    end

    if vim.g.session_file == nil or vim.v.vim_did_enter then
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
    local uv = vim.uv
    local to_save = {}

    to_save.pid = vim.b[bufnr].terminal_job_pid

    pcall(function()
        local data_dir = vim.fn.stdpath("state") .. "/terminal_data/" .. to_save.pid
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

    require("sessions.vars").to_save.buf(bufnr).term_data = to_save
end

local function restore_terminal(bufnr)
    local sessions = require("sessions.vars")
    local buf_data = sessions.loaded.buf(bufnr)
    local term_data = buf_data.term_data or {}
    local mux_vars = buf_data.vars.mux or {}

    local new_pid = vim.b[bufnr].terminal_job_pid
    local restore_cmds = {}

    if mux_vars.USER ~= nil and mux_vars.USER.pwd ~= nil then
        table.insert(restore_cmds, 'cd "' .. mux_vars.USER.pwd .. '"')
    end

    if term_data.contents_file ~= nil then
        table.insert(restore_cmds, 'cat "' .. term_data.contents_file .. '"')
        table.insert(restore_cmds, 'rm "' .. term_data.contents_file .. '"')
    end

    if term_data.history_file ~= nil then
        table.insert(
            restore_cmds,
            "mv '" .. term_data.history_file .. "' '" .. histfile(new_pid) .. "'"
        )
        table.insert(restore_cmds, "export SAVEHIST=1000")
        table.insert(restore_cmds, "export HISTFILE='" .. histfile(new_pid) .. "'")
        table.insert(restore_cmds, "setopt share_history")
    end

    if term_data.data_dir ~= nil then
        table.insert(restore_cmds, 'rmdir "' .. term_data.data_dir .. '"')
    end

    if term_data.pid ~= nil then
        table.insert(restore_cmds, 'echo "\n -- RESTORED ' .. term_data.pid .. '" --')
    end

    local hook_value = table.concat(restore_cmds, "\n")
    if zshrc_hooks[bufnr] then
        zshrc_hooks[bufnr].value = hook_value
        execute_zshrc_hook(zshrc_hooks[bufnr])
    else
        zshrc_hooks[bufnr] = {
            value = hook_value,
        }
    end
end

local function configure_terminal(bufnr)
    if vim.bo[bufnr].buftype ~= "terminal" then
        vim.print("Not a terminal buffer: " .. bufnr)
    end

    vim.opt_local.number = false
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
    pattern = "ExtendedSessionWritePre",
    group = augroup,
    callback = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal" then
                save_terminal(buf)
            end
        end
        -- TODO use uv
        os.execute("rmdir " .. state_dir)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "ExtendedSessionLoadPost",
    group = augroup,
    callback = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == "terminal" then
                restore_terminal(buf)
                configure_terminal(buf)
            end
        end
        return true
    end,
})

local function term_enter()
    vim.cmd.NoMatchParen()
    vim.opt.hlsearch = false
end

local function term_leave()
    vim.cmd.DoMatchParen()
    vim.opt.hlsearch = true
end

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        configure_terminal(vim.api.nvim_get_current_buf())
        if vim.v.vim_did_enter then
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
