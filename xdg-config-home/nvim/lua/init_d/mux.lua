if vim.env.USE_NTM ~= nil then
    vim.o.showtabline = 2
end

local M = {}

-- set mux vars and other data

function M.set_vars(args)
    local buffer = args.buffer
    local dict = vim.b[buffer].mux or {}
    for name, val in pairs(args.vars) do
        if val == "" then
            dict[name] = nil
        else
            dict[name] = val
        end
    end
    vim.b[buffer].mux = dict
    vim.cmd.redrawtabline()
end

function M.lcd(args)
    local buffer = args.buffer
    local dir = args.dir
    M.set_vars({
        buffer = buffer,
        vars = {
            pwd = dir,
        },
    })
    vim.api.nvim_buf_call(buffer, function()
        vim.cmd.lcd(dir)
    end)
end

function M.pid_to_bufnr(pid)
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        if vim.b[buf].terminal_job_pid == pid then
            return buf
        end
    end
    return -1
end

-- get mux vars

local function get_default_icon_color(buf)
    if vim.bo[buf].buftype == "terminal" then
        return "", "lightgreen"
    end

    local devicons = require("nvim-web-devicons")
    local icon, color =
        devicons.get_icon_color_by_filetype(vim.bo[buf].filetype, { default = false })
    if icon ~= nil then
        return icon, color
    end

    local default_icon = devicons.get_default_icon()
    return default_icon.icon, default_icon.color
end

local get_default_title = function(buf)
    if vim.bo[buf].buftype == "terminal" then
        return vim.b[buf].term_title
    end

    local bufname = vim.api.nvim_buf_get_name(buf)
    local basename = vim.fn.fnamemodify(bufname, ":t")
    if basename == nil or basename == "" then
        return "[No Name]"
    end
    return basename
end

local get_default_title_style = function(buf)
    if vim.bo[buf].buftype == "terminal" then
        return "default"
    elseif vim.bo[buf].modified then
        return "italic"
    else
        return "default"
    end
end

function M.get_vars(buf)
    buf = buf or vim.api.nvim_get_current_buf()

    local mux_vars = vim.b[buf].mux or {}
    local icon, icon_color = get_default_icon_color(buf)
    return {
        icon = mux_vars.icon or icon,
        icon_color = mux_vars.icon_color or icon_color,
        title = mux_vars.title or get_default_title(buf),
        title_style = mux_vars.title_style or get_default_title_style(buf),
    }
end

local augroup = vim.api.nvim_create_augroup("AweMux", {})
vim.api.nvim_create_autocmd("BufNew", {
    group = augroup,
    callback = function(ev)
        vim.b[ev.buf].mux = {}
        vim.cmd.redrawtabline()
    end,
})

require("sessions").register_buf_vars({ "mux" })

if vim.env.USE_NTM == nil then
    local refresh_parent_vars = function()
        local mux_vars = M.get_vars()
        local rename_window = vim.env.XDG_CONFIG_HOME .. "/zsh/functions/rename_window"
        local handle
        handle = vim.loop.spawn("zsh", {
            args = { rename_window, mux_vars.title, mux_vars.icon, mux_vars.title_style },
        }, function()
            if handle ~= nil then
                handle:close()
            end
        end)
    end

    vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        callback = refresh_parent_vars,
    })
    vim.api.nvim_create_autocmd("VimEnter", {
        group = augroup,
        callback = refresh_parent_vars,
    })
end

return M
