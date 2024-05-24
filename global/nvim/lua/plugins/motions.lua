return {
    "michaeljsmith/vim-indent-object",
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = false,
                        include_surrounding_whitespace = false,
                        keymaps = {
                            ["aa"] = {
                                query = "@parameter.outer",
                                desc = "Select a paramter/argument",
                            },
                            ["ia"] = {
                                query = "@parameter.inner",
                                desc = "Select a paramter/argument, not including comma",
                            },
                            ["af"] = {
                                query = "@function.outer",
                                desc = "Select a function",
                            },
                            ["if"] = {
                                query = "@function.inner",
                                desc = "Select the body of a function",
                            },
                            ["ac"] = {
                                query = "@class.outer",
                                desc = "Select a class",
                            },
                            ["ic"] = {
                                query = "@class.inner",
                                desc = "Select the body of a class",
                            },
                            ["as"] = {
                                query = "@scope",
                                query_group = "locals",
                                desc = "Select a language scope",
                            },
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]a"] = {
                                query = "@parameter.outer",
                                desc = "Goto next paramter/argument",
                            },
                            ["]f"] = {
                                query = "@function.outer",
                                desc = "Goto next function",
                            },
                            ["]c"] = {
                                query = "@class.outer",
                                desc = "Goto next class",
                            },
                            ["]s"] = {
                                query = "@scope",
                                query_group = "locals",
                                desc = "Goto next language scope",
                            },
                        },
                        goto_prev_start = {
                            ["[a"] = {
                                query = "@parameter.outer",
                                desc = "Goto previous paramter/argument",
                            },
                            ["[f"] = {
                                query = "@function.outer",
                                desc = "Goto previous function",
                            },
                            ["[c"] = {
                                query = "@class.outer",
                                desc = "Goto previous class",
                            },
                            ["[s"] = {
                                query = "@scope",
                                query_group = "locals",
                                desc = "Goto previous language scope",
                            },
                        },
                    },
                },
            })
        end,
    },
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
