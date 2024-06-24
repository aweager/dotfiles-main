vim.o.termguicolors = true
vim.o.list = true
vim.opt.listchars = {
    tab = "  ",
    trail = "•",
    extends = "→",
    precedes = "←",
}

M = {}

M.tabline = {
    bg = vim.env.MACHINE_COLOR or "cyan",

    head = {
        fg = "black",
    },

    current_tab = {
        fg = "white",
        bold = true,
        ctermfg = "white",
        cterm = {
            bold = true,
        },
    },

    not_current_tab = {
        bg = "#585858",
        ctermbg = 240,
        cterm = {},
    },
}

function M.tabline._load_cache()
    if M.tabline._cache ~= nil then
        return M.tabline._cache
    end

    vim.api.nvim_set_hl(0, "TabLineCurrentDefault", M.tabline.current_tab)
    vim.api.nvim_set_hl(0, "TabLineNotCurrentDefault", M.tabline.not_current_tab)

    local currentItalic = vim.deepcopy(M.tabline.current_tab)
    currentItalic.italic = true
    currentItalic.cterm.italic = true
    vim.api.nvim_set_hl(0, "TabLineCurrentItalic", currentItalic)

    local notCurrentItalic = vim.deepcopy(M.tabline.not_current_tab)
    notCurrentItalic.italic = true
    notCurrentItalic.cterm.italic = true
    vim.api.nvim_set_hl(0, "TabLineNotCurrentItalic", notCurrentItalic)

    M.tabline._cache = {
        current = {
            default = "TabLineCurrentDefault",
            italic = "TabLineCurrentItalic",
        },
        not_current = {
            default = "TabLineNotCurrentDefault",
            italic = "TabLineNotCurrentItalic",
        },
    }
    return M.tabline._cache
end

function M.tabline.get_title_hl(mux_vars, is_current)
    local cache = M.tabline._load_cache()
    local key1 = is_current and "current" or "not_current"
    local key2 = mux_vars.title_style
    return cache[key1][key2]
end

function M.tabline.get_icon_hl(mux_vars, is_current)
    if not is_current then
        return M.tabline.not_current_tab
    end

    local ret = vim.deepcopy(M.tabline.current_tab)

    if mux_vars.icon_color ~= nil then
        ret.fg = mux_vars.icon_color
    end

    return ret
end

function M.tabline.get_head()
    return {
        fg = M.tabline.head.fg,
        bg = M.tabline.head.bg or M.tabline.bg,
    }
end

function M.tabline.get_fill()
    return {
        fg = M.tabline.bg,
        bg = M.tabline.bg,
    }
end

M.winbar = {
    underline_color = "#888888",
}

M.windows = {
    separator = {
        fg = "darkgray",
        bold = true,
    },
}

M.listchars = {
    non_text = {
        bg = "darkgreen",
        ctermbg = "darkgreen",
    },
    whitespace = {
        fg = "#464646",
        ctermfg = "darkgray",
    },
}

M.context = {
    bg = "#333333",
    underline_color = "gray",
}

M.indent_guides = {
    char = "▏",
}

return M
