vim.keymap.set("n", "<leader>z", function()
    vim.cmd.nohlsearch()
end, {
    silent = true,
    desc = "Turn off search result highlighting",
})

vim.keymap.set("n", "<leader>E", function()
    local win_to_close = vim.api.nvim_get_current_win()
    vim.cmd("tab split")
    vim.api.nvim_win_close(win_to_close, false)
end, {
    silent = true,
    desc = "{E}xpand the current buffer into its own tab",
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
        vim.keymap.set("n", "<leader>D", function()
            vim.cmd("tab split")
            vim.lsp.buf.definition()
        end, {
            buffer = ev.buf,
            desc = "Go to {D}efinition in a new tab",
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
        vim.keymap.set("n", "<leader>H", function()
            local filter = { bufnr = vim.fn.bufnr() }
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
        end, {
            buffer = ev.buf,
            desc = "Toggle inlay {H}ints",
        })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
            buffer = ev.buf,
            desc = "Display diagnostic info",
        })
    end,
})
