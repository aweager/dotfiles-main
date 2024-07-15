return {
    "michaeljsmith/vim-indent-object",
    {
        "bkad/CamelCaseMotion",
        config = function()
            local opts = { silent = true }
            vim.keymap.set("o", "i_", "<Plug>CamelCaseMotion_iw", opts)
            vim.keymap.set("x", "i_", "<Plug>CamelCaseMotion_iw", opts)
            vim.keymap.set("o", "a_", "<Plug>CamelCaseMotion_aw", opts)
            vim.keymap.set("x", "a_", "<Plug>CamelCaseMotion_aw", opts)
        end,
    },
}
