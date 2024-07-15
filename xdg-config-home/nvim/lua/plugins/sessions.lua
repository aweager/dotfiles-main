return {
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/nvim-sessions",
        main = "sessions",
        name = "sessions",
        config = function()
            if vim.env.NVIM_SESSION_FILE then
                require("sessions").setup({
                    session_file = vim.env.NVIM_SESSION_FILE,
                })
            end
        end,
    },
}
