-- TODO source header from mux vars
local head = "  [" .. vim.fn.fnamemodify(vim.g.root_dir, ":t") .. "] "

local tabline = { "nanozuki/tabby.nvim" }
tabline.dependencies = { "nvim-web-devicons", "mux-api" }
tabline.config = function()
    require("tabby.tabline").set(function(line)
        local theme = require("init_d.themeconfig").tabline
        local mux = require("mux.api")
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
                local mux_vars = assert(mux.resolve_info("t:" .. tab.id))
                local title = mux_vars.title
                local title_hl = theme.get_title_hl(mux_vars, tab.is_current())
                local icon_hl = theme.get_icon_hl(mux_vars, tab.is_current())

                if vim.t[tab.id].is_pinned then
                    title = ""
                end

                return {
                    line.sep("", title_hl, fill),
                    {
                        " " .. mux_vars.icon .. " ",
                        hl = icon_hl,
                    },
                    title:len() > 0 and (title .. " ") or "",
                    line.sep("", title_hl, fill),
                    hl = title_hl,
                }
            end),
            line.spacer(),
            hl = fill,
        }
    end, {})
end

return { tabline }
