table.insert(require("langs"), {
    langs = {
        {
            name = "lua",
            filetypes = { "lua" },
            lsp = "lua_ls",
            formatters = { "stylua" },
        },
    },
    lsps = {
        { name = "lua_ls" },
    },
    formatters = {
        { name = "stylua" },
    },
})
