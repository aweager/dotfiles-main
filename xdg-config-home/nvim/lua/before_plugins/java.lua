table.insert(require("langs"), {
    langs = {
        {
            name = "java",
            filetypes = { "java" },
            lsp = "jdtls",
        },
    },
    lsps = {
        {
            name = "jdtls",
            lspconfig = {},
        },
    },
})
