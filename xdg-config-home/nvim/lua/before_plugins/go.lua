table.insert(require("langs"), {
    langs = {
        {
            name = "go",
            filetypes = { "go" },
            lsp = "gopls",
            formatters = { "gofmt" },
        },
    },
    lsps = {
        {
            name = "gopls",
            lspconfig = {},
        },
    },
    formatters = {
        { name = "gofmt" },
    },
})

local group = vim.api.nvim_create_augroup("AweGolangSetup", {})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.go",
    group = group,
    desc = "Unset expandtab for golang",
    callback = function()
        vim.bo.expandtab = false
    end,
})
