return {
    {
        enabled = false,
        "direnv/direnv.vim",
        init = function()
            vim.g.direnv_auto = 0
        end,
    },
}
