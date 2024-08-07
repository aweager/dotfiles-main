vim.keymap.set("n", "<leader>z", function()
    vim.cmd.nohlsearch()
end, {
    silent = true,
    desc = "Turn off search result highlighting",
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("AweLspConfig", {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings (after lsp attaches)
        -- see `:help vim.lsp.*` for docs on functions
        vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, {
            buffer = ev.buf,
            desc = "Go to {d}efinition",
        })
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, {
            buffer = ev.buf,
            desc = "Go to {i}mplementation",
        })
        vim.keymap.set("n", "<leader>u", vim.lsp.buf.references, {
            buffer = ev.buf,
            desc = "Find {u}ses (references)",
        })
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {
            buffer = ev.buf,
            desc = "{r}ename symbol",
        })
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action, {
            buffer = ev.buf,
            desc = "Apply {f}ix (via code_action)",
        })
        vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, {
            buffer = ev.buf,
            desc = "Display {h}over info",
        })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
            buffer = ev.buf,
            desc = "Display diagnostic info",
        })
    end,
})
