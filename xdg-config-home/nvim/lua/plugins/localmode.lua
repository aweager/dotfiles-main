return {
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/localmode",
        name = "localmode",
        main = "localmode",
        config = function()
            require("sessions.vars").register_win_vars({ "local_mode" })
            require("localmode").setup()
        end,
    },
}
