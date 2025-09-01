vim.o.termguicolors = true
vim.o.list = true
vim.opt.listchars = {
    tab = "  ",
    trail = "•",
    extends = "→",
    precedes = "←",
}

local M = {}

M.tabline = {
    bg = vim.env.MACHINE_COLOR or "cyan",

    head = {
        fg = "black",
        bg = vim.env.MACHINE_COLOR or "cyan",
    },

    fill = {
        fg = "black",
        bg = vim.env.MACHINE_COLOR or "cyan",
    },

    current_tab_config = {
        fg = "white",
        bg = "#1f1f1f",
        bold = true,
        ctermfg = "white",
        cterm = {
            bold = true,
        },
    },

    current_tab = function(style)
        local ret = vim.deepcopy(M.tabline.current_tab_config)
        if style == "italic" then
            ret.italic = true
            ret.cterm.italic = true
        end
        return ret
    end,

    not_current_tab_config = {
        fg = "white",
        bg = "#444444",
        cterm = {},
    },

    not_current_tab = function(style)
        local ret = vim.deepcopy(M.tabline.not_current_tab_config)
        if style == "italic" then
            ret.italic = true
            ret.cterm.italic = true
        end
        return ret
    end,

    get_title_hl = function(mux_vars, is_current)
        if is_current then
            if mux_vars.title_style == "italic" then
                return "TabLineCurrentItalic"
            else
                return "TabLineCurrentDefault"
            end
        else
            if mux_vars.title_style == "italic" then
                return "TabLineNotCurrentItalic"
            else
                return "TabLineNotCurrentDefault"
            end
        end
    end,

    get_icon_hl = function(mux_vars, is_current)
        local pre_mod = M.tabline.current_tab
        if not is_current then
            pre_mod = M.tabline.not_current_tab
        end

        local ret = vim.deepcopy(pre_mod(mux_vars.title_style))

        if mux_vars.icon_color ~= nil then
            ret.fg = mux_vars.icon_color
        end

        return ret
    end,
}

M.winbar = {
    underline_color = "#888888",

    get_icon_hl = function(mux_vars, winnr)
        local w = vim.w[winnr]
        if w.winbar_cache == nil then
            w.winbar_cache = {}
        end

        if mux_vars.icon_color == nil then
            return "WinbarTitleDefault"
        end

        if w.icon_color == mux_vars.icon_color then
            return w.icon_hl
        end

        w.icon_hl = string.format("WinbarIcon_%s", winnr)
        vim.api.nvim_set_hl(
            0,
            w.icon_hl,
            vim.tbl_extend(
                "force",
                vim.api.nvim_get_hl(0, { name = "WinbarTitleDefault", link = false }),
                {
                    fg = mux_vars.icon_color,
                }
            )
        )
        return w.icon_hl
    end,

    get_title_hl = function(mux_vars)
        if mux_vars.title_style == "italic" then
            return "WinbarTitleItalic"
        else
            return "WinbarTitleDefault"
        end
    end,
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

M.hints = {
    diagnostic_hint = {
        fg = "#555555",
    },
    diagnostic_info = {
        fg = "#555555",
    },
    inlay_hint = {
        fg = "#555555",
    },
}

M.terminal = {
    -- TODO: unify this list somehow with wezterm, which is where i got it from
    colors = {
        "#000000",
        "#cc5555",
        "#55cc55",
        "#cdcd55",
        "#5455cb",
        "#cc55cc",
        "#7acaca",
        "#cccccc",

        "#555555",
        "#ff5555",
        "#55ff55",
        "#ffff55",
        "#5555ff",
        "#ff55ff",
        "#55ffff",
        "#ffffff",
    },
}

return M
