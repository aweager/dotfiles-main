table.insert(require("langs"), {
    langs = {
        {
            name = "markdown",
            filetypes = { "markdown" },
            formatters = { "prettier" },
        },
    },
    formatters = {
        {
            name = "prettier",
            formatter_override = {
                prepend_args = { "--prose-wrap", "always" },
            },
        },
    },
})
