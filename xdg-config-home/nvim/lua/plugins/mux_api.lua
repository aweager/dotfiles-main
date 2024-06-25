-- plugins that help with config files
return {
    {
        dir = vim.env.HOME .. "/projects/nvim-mux",
        main = "mux",
        config = function()
            require("mux").setup()
        end,
    },
}
