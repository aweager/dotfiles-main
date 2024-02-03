-- window-local buffer history

local augroup = vim.api.nvim_create_augroup("AweBufferHistory", {})

vim.api.nvim_create_autocmd("SessionLoadPost", {
    group = augroup,
    callback = function()
        for _, win in pairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            vim.w[win].buffer_history = { buf }
            vim.w[win].buffer_history_index = 0
        end
    end,
})

return {
    {
        "dhruvasagar/vim-buffer-history",
        config = function()
            local opts = { silent = true }
            vim.keymap.set("n", "<c-p>", vim.cmd.BufferHistoryBack, opts)
            vim.keymap.set("n", "<c-n>", vim.cmd.BufferHistoryForward, opts)
        end,
    },
}
