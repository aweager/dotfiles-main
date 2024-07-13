return {
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/nvim-sessions",
        main = "sessions",
        name = "sessions",
        enabled = function()
            return vim.env.NVIM_SESSION_FILE ~= nil
        end,
        config = function()
            require("sessions").setup({
                session_file = vim.env.NVIM_SESSION_FILE,
            })
        end,
    },
}
