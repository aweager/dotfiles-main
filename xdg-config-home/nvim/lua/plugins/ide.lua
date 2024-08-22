return {
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/ide-config.nvim",
        name = "ide-config",
        main = "ide-config",
        config = function()
            local ide = require("ide-config")

            ide.configure_langs({
                {
                    name = "python",
                    filetypes = { "python" },
                    lsp = "basedpyright",
                    formatters = { "black", "isort" },
                },
                {
                    name = "cpp",
                    filetypes = { "cpp", "c" },
                    lsp = "clangd",
                    formatters = { "clangformat" },
                },
                {
                    name = "lua",
                    filetypes = { "lua" },
                    lsp = "lua_ls",
                    formatters = { "stylua" },
                },
            })

            ide.configure_lsps({
                { name = "pyright" },
                {
                    name = "basedpyright",
                    lspconfig = {
                        settings = {
                            basedpyright = {
                                typeCheckingMode = "standard",
                            },
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly",
                            },
                        },
                    },
                },
                {
                    name = "pylsp",
                    lspconfig = {
                        settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = {
                                        enabled = false,
                                    },
                                    rope_autoimport = {
                                        enabled = true,
                                    },
                                },
                            },
                        },
                    },
                },
                { name = "lua_ls" },
                {
                    name = "clangd",
                    lspconfig = {
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--enable-config",
                        },
                        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                    },
                },
            })

            ide.configure_formatters({
                { name = "clangformat" },
                { name = "black" },
                { name = "isort" },
                { name = "stylua" },
            })

            ide.configure_linters({
                { name = "mypy" },
            })
        end,
    },
}
