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
                    lsp = "pyright",
                    linter = "mypy",
                    formatter = "black",
                },
                {
                    name = "cpp",
                    filetypes = { "cpp", "c" },
                    lsp = "clangd",
                    formatter = "clangformat",
                },
                {
                    name = "lua",
                    filetypes = { "lua" },
                    lsp = "lua_ls",
                    formatter = "stylua",
                },
            })

            ide.configure_lsps({
                { name = "pyright" },
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
                { name = "stylua" },
            })

            ide.configure_linters({
                { name = "mypy" },
            })
        end,
    },
}
