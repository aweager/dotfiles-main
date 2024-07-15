local treesitter = { "nvim-treesitter/nvim-treesitter" }
treesitter.dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
}
treesitter.config = function()
    require("nvim-treesitter.configs").setup({ ---@diagnostic disable-line: missing-fields
        -- A list of parser names, or "all" (the listed parsers should always be installed)
        ensure_installed = { "cpp", "lua", "vim", "vimdoc", "query" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
            enable = true,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
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
                goto_next_end = {
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
                goto_previous_start = {
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
end

local rainbow_highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

return {
    treesitter,
    {
        "lukas-reineke/indent-blankline.nvim",
        dependencies = {
            "HiPhish/rainbow-delimiters.nvim",
        },
        main = "ibl",
        config = function()
            require("ibl").setup()
            local hooks = require("ibl.hooks")
            -- create the highlight groups in the highlight setup hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            local themeconfig = require("init_d.themeconfig").indent_guides
            require("rainbow-delimiters.setup").setup({
                highlight = rainbow_highlight,
            })
            require("ibl").setup({
                indent = {
                    char = themeconfig.char,
                },
                scope = {
                    highlight = rainbow_highlight,
                    show_start = false,
                    show_end = false,
                },
            })

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("treesitter-context").setup({
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 1, -- Maximum number of lines to show for a single context
                trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20, -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            })
        end,
    },
}
