table.insert(require("langs"), {
    langs = {
        {
            name = "cpp",
            filetypes = { "cpp", "c" },
            lsp = "clangd",
            formatters = { "clangformat" },
        },
    },
    lsps = {
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
    },
    formatters = {
        { name = "clangformat" },
    },
})
