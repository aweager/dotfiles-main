table.insert(require("langs"), {
    langs = {
        {
            name = "rust",
            filetypes = { "rust" },
            lsp = "rust_analyzer",
        },
    },
    lsps = {
        {
            name = "rust_analyzer",
            lspconfig = {
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = {
                            enable = true,
                        },
                    },
                },
            },
        },
    },
})
