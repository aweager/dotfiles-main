-- window-local buffer history

local augroup = vim.api.nvim_create_augroup("AweBufferHistory", {})
local sessions = require("sessions")

sessions.register_win_vars({ "buffer_history", "buffer_history_index" })
vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "AweSessionLoadPost",
    callback = function()
        for _, win in pairs(vim.api.nvim_list_wins()) do
            if not vim.w[win].buffer_history then
                vim.w[win].buffer_history = {
                    vim.api.nvim_win_get_buf(win),
                }
                vim.w[win].buffer_history_index = 0
                return
            end

            local corrected_history = {}
            for _, old_id in pairs(vim.w[win].buffer_history) do
                table.insert(corrected_history, sessions.find_new_bufid(old_id))
            end
            vim.w[win].buffer_history = corrected_history
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
