return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")
            local themes = require("telescope.themes")
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            width = 0.9,
                            height = 0.9,
                            preview_height = 0.6,
                            preview_cutoff = 0,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        themes.get_cursor({}),
                    },
                },
            })
            telescope.load_extension("ui-select")

            local augroup = vim.api.nvim_create_augroup("AweTelescope", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = augroup,
                callback = function(ev)
                    vim.keymap.set("n", "<leader>u", builtin.lsp_references, {
                        buffer = ev.buf,
                        desc = "Find {u}ses (references)",
                    })
                    vim.keymap.set("n", "<leader>s", builtin.lsp_dynamic_workspace_symbols, {
                        buffer = ev.buf,
                        desc = "Find {s}ymbol",
                    })
                end,
            })

            vim.keymap.set("n", "<leader>o", function()
                builtin.find_files({
                    cwd = vim.g.root_dir,
                })
            end, {
                silent = true,
                desc = "{o}pen a file",
            })

            vim.keymap.set("n", "<leader>/", function()
                builtin.grep_string({
                    cwd = vim.g.root_dir,
                    shorten_path = true,
                    word_match = "-w",
                    only_sort_text = true,
                    search = "",
                })
            end, {
                silent = true,
                desc = "Search within files",
            })

            vim.keymap.set("n", "<leader>b", builtin.buffers, {
                silent = true,
                desc = "Search open {b}uffers",
            })

            vim.keymap.set("n", "<leader>t", builtin.resume, {
                silent = true,
                desc = "Resume last {t}elescope search",
            })
        end,
    },
    {
        "rcarriga/nvim-notify",
        config = function()
            vim.notify = require("notify")
        end,
    },
    {
        "stevearc/dressing.nvim",
        opts = {
            select = {
                enabled = false,
            },
        },
    },
}
