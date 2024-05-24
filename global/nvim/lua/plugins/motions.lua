return {
    "michaeljsmith/vim-indent-object",
    "wellle/targets.vim",
    {
        "bkad/CamelCaseMotion",
        config = function()
            local opts = { silent = true }
            vim.keymap.set("n", "=", "<Plug>CamelCaseMotion_w", opts)
            vim.keymap.set("n", "+", "<Plug>CamelCaseMotion_w", opts)
            vim.keymap.set("n", "\\", "<Plug>CamelCaseMotion_w", opts)

            vim.keymap.set("o", "i_", "<Plug>CamelCaseMotion_iw", opts)
            vim.keymap.set("x", "i_", "<Plug>CamelCaseMotion_iw", opts)
            vim.keymap.set("o", "a_", "<Plug>CamelCaseMotion_aw", opts)
            vim.keymap.set("x", "a_", "<Plug>CamelCaseMotion_aw", opts)
        end,
    },
}
