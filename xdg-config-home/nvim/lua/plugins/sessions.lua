return {
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/nvim-sessions",
        main = "sessions",
        name = "sessions",
        config = function()
            if vim.env.NVIM_SESSION_NAME then
                require("sessions").setup({
                    session_name = vim.env.NVIM_SESSION_NAME,
                })
            end
        end,
    },
}
