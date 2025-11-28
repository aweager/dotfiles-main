table.insert(require("langs"), {
    langs = {
        {
            name = "proto",
            filetypes = { "proto" },
            lsp = "buf_ls",
            formatters = { "buf" },
        },
    },
    lsps = {
        {
            name = "buf_ls",
            lspconfig = {},
        },
    },
    formatters = {
        { name = "buf" },
    },
})
