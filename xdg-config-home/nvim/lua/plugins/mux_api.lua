return {
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/nvim-mux",
        main = "mux",
        name = "mux-api",
        config = function()
            require("mux").setup()

            if vim.env.USE_NTM ~= nil then
                vim.o.showtabline = 2
                require("mux.api").set_info("s:0", {
                    icon = "",
                    icon_color = "green",
                    title = vim.fn.fnamemodify(vim.g.root_dir, ":t"),
                    title_style = "default",
                })
            end

            require("mux.api").register_user_callback("pwd", function(location, key, value)
                vim.cmd("silent! lcd " .. value)
            end)

            require("sessions").register_buf_vars({ "mux" })
            require("sessions").register_win_vars({ "mux" })
            require("sessions").register_tab_vars({ "mux" })
            require("sessions").register_global_vars({ "mux" })
        end,
    },
}
