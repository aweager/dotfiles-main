vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("AweLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings (after lsp attaches)
        -- see `:help vim.lsp.*` for docs on functions
        vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, {
            buffer = ev.buf,
            desc = "Go to {d}efinition",
        })
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, {
            buffer = ev.buf,
            desc = "Go to {i}mplementation",
        })
        vim.keymap.set("n", "<leader>u", vim.lsp.buf.references, {
            buffer = ev.buf,
            desc = "Find {u}ses (references)",
        })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {
            buffer = ev.buf,
            desc = "{r}ename symbol",
        })
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action, {
            buffer = ev.buf,
            desc = "Apply {f}ix (via code_action)",
        })
        vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, {
            buffer = ev.buf,
            desc = "Display {h}over info",
        })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
            buffer = ev.buf,
            desc = "Display diagnostic info",
        })
    end,
})

vim.lsp.inlay_hint.enable()

-- TODO in lua
vim.cmd([[
    highlight DiagnositHint ctermfg=darkgray guifg=darkgray
    highlight DiagnositInfo ctermfg=darkgray guifg=darkgray
]])

return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                PATH = "append",
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "folke/neodev.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("neodev").setup()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers({
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup({
                        capabilities = default_capabilities,
                    })
                end,

                clangd = function()
                    require("lspconfig").clangd.setup({
                        capabilities = default_capabilities,
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--enable-config",
                        },
                        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                    })
                end,

                lua_ls = function()
                    require("neodev").setup({
                        override = function(root_dir, library)
                            library.enabled = true
                            library.plugins = true
                        end,
                    })
                    require("lspconfig").lua_ls.setup({
                        capabilities = default_capabilities,
                    })
                end,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "SmiteshP/nvim-navbuddy",
                dependencies = {
                    "SmiteshP/nvim-navic",
                    "MunifTanjim/nui.nvim",
                },
                opts = { lsp = { auto_attach = true } },
            },
        },
    },
}
