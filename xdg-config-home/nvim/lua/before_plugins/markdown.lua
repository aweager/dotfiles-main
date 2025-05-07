local augroup = vim.api.nvim_create_augroup("AweMarkdown", {})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    desc = "Set markdown filetype options",
    pattern = "markdown",
    callback = function()
        vim.b.buffer_wrap = true
        vim.b.buffer_linebreak = true
        vim.wo.wrap = true
        vim.wo.linebreak = true
        vim.bo.textwidth = 80
        vim.bo.formatoptions = vim.bo.formatoptions .. "a"
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    desc = "Set window-related options for markdown",
    callback = function()
        vim.wo.wrap = vim.b.buffer_wrap or nil
        vim.wo.linebreak = vim.b.buffer_linebreak or nil
    end,
})

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
