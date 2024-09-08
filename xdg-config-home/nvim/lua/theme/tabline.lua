local tabline = { "nanozuki/tabby.nvim" }
tabline.dependencies = { "nvim-web-devicons", "mux-api", "Mofiqul/vscode.nvim" }
tabline.config = function()
    require("tabby.tabline").set(function(line)
        local theme = require("init_d.themeconfig").tabline
        local mux = require("mux.api")

        local head_component = { "" }
        if vim.env.USE_NTM then
            local head_vars = mux.resolve_info("s:0")
            head_component = {
                string.format(" %s [%s] ", head_vars.icon, head_vars.title),
                hl = "TabLineHead",
                margin = " ",
            }
        end

        return {
            { head_component },
            line.tabs().foreach(function(tab)
                local mux_vars = assert(mux.resolve_info("t:" .. tab.id))
                local title = mux_vars.title
                local title_hl = theme.get_title_hl(mux_vars, tab.is_current())
                local icon_hl = theme.get_icon_hl(mux_vars, tab.is_current())

                if vim.t[tab.id].is_pinned then
                    title = ""
                end

                return {
                    line.sep("", title_hl, "TabLineFill"),
                    {
                        " " .. mux_vars.icon .. " ",
                        hl = icon_hl,
                    },
                    title:len() > 0 and (title .. " ") or "",
                    line.sep("", title_hl, "TabLineFill"),
                    hl = title_hl,
                }
            end),
            line.spacer(),
            hl = "TabLineFill",
        }
    end, {})
end

return { tabline }
