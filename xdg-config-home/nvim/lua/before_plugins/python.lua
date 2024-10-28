table.insert(require("langs"), {
    langs = {
        {
            name = "python",
            filetypes = { "python" },
            lsp = "basedpyright",
            formatters = { "black", "isort" },
        },
    },
    lsps = {
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
    },
    formatters = {
        { name = "black" },
        { name = "isort" },
    },
    linters = {
        { name = "mypy" },
    },
})
