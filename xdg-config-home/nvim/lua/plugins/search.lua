local fzf = {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")

        fzf.setup({
            winopts = {
                height = 0.9,
                width = 0.9,
                preview = {
                    layout = "vertical",
                    vertical = "up:75%",
                },
                on_create = function()
                    vim.keymap.set("t", "<C-j>", "<Down>", { silent = true, buffer = true })
                    vim.keymap.set("t", "<C-k>", "<Up>", { silent = true, buffer = true })
                end,
            },
            keymap = {
                builtin = {
                    ["<C-e>"] = "preview-down",
                    ["<C-y>"] = "preview-up",
                    ["<C-d>"] = "preview-page-down",
                    ["<C-u>"] = "preview-page-up",
                },
            },
        })

        local augroup = vim.api.nvim_create_augroup("AweFzf", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
            group = augroup,
            callback = function(ev)
                vim.keymap.set("n", "<leader>u", fzf.lsp_references, {
                    buffer = ev.buf,
                    desc = "Find {u}ses (references)",
                })
                vim.keymap.set("n", "<leader>au", function()
                    fzf.lsp_references({ resume = true })
                end, {
                    silent = true,
                    desc = "Resume {a}gain last {u}ses search",
                })

                vim.keymap.set("n", "<leader>s", fzf.lsp_live_workspace_symbols, {
                    buffer = ev.buf,
                    desc = "Find {s}ymbol",
                })
                vim.keymap.set("n", "<leader>as", function()
                    fzf.lsp_live_workspace_symbols({ resume = true })
                end, {
                    silent = true,
                    desc = "Resume {a}gain last {s}ymbol search",
                })
            end,
        })

        if vim.uv.fs_stat(vim.g.root_dir .. "/.git") then
            vim.keymap.set("n", "<leader>o", function()
                fzf.git_files({
                    cwd = vim.g.root_dir,
                    cwd_header = false,
                })
            end, {
                silent = true,
                desc = "{o}pen a file",
            })
            vim.keymap.set("n", "<leader>ao", function()
                fzf.git_files({ resume = true })
            end, {
                silent = true,
                desc = "Resume {a}gain last {o}pen search",
            })
        else
            vim.keymap.set("n", "<leader>o", function()
                fzf.files({
                    cwd = vim.g.root_dir,
                    cwd_prompt = false,
                })
            end, {
                silent = true,
                desc = "{o}pen a file",
            })
            vim.keymap.set("n", "<leader>ao", function()
                fzf.files({ resume = true })
            end, {
                silent = true,
                desc = "Resume {a}gain last {o}pen search",
            })
        end

        vim.keymap.set("n", "<leader>/", function()
            fzf.grep({
                cwd = vim.g.root_dir,
                cwd_prompt = false,
                lgrep = true,
                search = "",
            })
        end, {
            silent = true,
            desc = "Search{/} within files",
        })
        vim.keymap.set("n", "<leader>a/", function()
            fzf.grep({ resume = true })
        end, {
            silent = true,
            desc = "Resume {a}gain last search{/} within files",
        })
    end,
}

return {
    fzf,
}
