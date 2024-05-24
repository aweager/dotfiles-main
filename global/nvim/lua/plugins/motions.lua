return {
    "michaeljsmith/vim-indent-object",
    "wellle/targets.vim",
    {
        "bkad/CamelCaseMotion",
        config = function()
            local opts = { silent = true }
            vim.keymap.set("o", "ic", "<Plug>CamelCaseMotion_iw", opts)
            vim.keymap.set("x", "ic", "<Plug>CamelCaseMotion_iw", opts)
            vim.keymap.set("o", "ac", "<Plug>CamelCaseMotion_aw", opts)
            vim.keymap.set("x", "ac", "<Plug>CamelCaseMotion_aw", opts)
        end,
    },
}
