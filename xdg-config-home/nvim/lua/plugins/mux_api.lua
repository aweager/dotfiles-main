return {
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/nvim-mux",
        main = "mux",
        name = "mux-api",
        config = function()
            require("mux").setup()

            if vim.env.USE_NTM ~= nil then
                vim.o.showtabline = 2
                local augroup = vim.api.nvim_create_augroup("AweMuxApi", {})
                vim.api.nvim_create_autocmd("VimEnter", {
                    group = augroup,
                    callback = function()
                        require("mux.api").set_info("s:0", {
                            icon = "",
                            icon_color = vim.env.MUX_PROMPT_ICON_COLOR or "green",
                            title = vim.fn.fnamemodify(vim.g.root_dir, ":t"),
                            title_style = "default",
                        })
                    end,
                })
            end

            require("mux.api").register_user_callback(
                "pwd",
                function(location, namespace, key, value)
                    vim.cmd("silent! lcd " .. value)
                end
            )

            local sessions_vars = require("sessions.vars")
            sessions_vars.register_buf_vars({ "mux" })
            sessions_vars.register_win_vars({ "mux" })
            sessions_vars.register_tab_vars({ "mux" })
            sessions_vars.register_global_vars({ "mux" })
        end,
    },
}
