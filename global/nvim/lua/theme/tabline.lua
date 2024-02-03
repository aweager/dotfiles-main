local head = "  [" .. vim.fn.fnamemodify(vim.g.root_dir, ":t") .. "] "

local tabline = { "nanozuki/tabby.nvim" }
tabline.dependencies = { "nvim-web-devicons" }
tabline.config = function()
    require("tabby.tabline").set(function(line)
        local theme = require("themeconfig").tabline
        local mux = require("mux")
        local tabmux = require("tabmux")
        local fill = theme.get_fill()
        return {
            {
                {
                    head,
                    hl = theme.get_head(),
                    margin = " ",
                },
            },
            line.tabs().foreach(function(tab)
                local buf = tab.current_win().buf().id
                local mux_vars = mux.get_vars(buf)
                local title = mux_vars.title
                local title_hl = theme.get_title_hl(mux_vars, tab.is_current())
                local icon_hl = theme.get_icon_hl(mux_vars, tab.is_current())

                local tab_mux_vars = tabmux.get_vars(tab.id)
                if tab_mux_vars.pinned then
                    title = ""
                elseif tab_mux_vars.name then
                    title = tab_mux_vars.name
                end

                return {
                    line.sep("", title_hl, fill),
                    {
                        mux_vars.icon,
                        hl = icon_hl,
                    },
                    title,
                    line.sep("", title_hl, fill),
                    hl = title_hl,
                    margin = " ",
                }
            end),
            line.spacer(),
            hl = fill,
        }
    end, {})
end

return { tabline }
