-- window-local buffer history

return {
    {
        "dhruvasagar/vim-buffer-history",
        dependencies = { "sessions" },
        config = function()
            local opts = { silent = true }
            vim.keymap.set("n", "<c-p>", vim.cmd.BufferHistoryBack, opts)
            vim.keymap.set("n", "<c-n>", vim.cmd.BufferHistoryForward, opts)

            local augroup = vim.api.nvim_create_augroup("AweBufferHistory", {})
            local sessions = require("sessions.vars")

            vim.api.nvim_create_autocmd("User", {
                pattern = "ExtendedSessionWritePre",
                group = augroup,
                callback = function()
                    for _, win in pairs(vim.api.nvim_list_wins()) do
                        if not vim.w[win].buffer_history then
                            local to_save = {}
                            to_save.buffer_history = vim.w[win].buffer_history
                            to_save.buffer_history_index = vim.w[win].buffer_history_index
                            sessions.to_save.win(win).buffer_history = to_save
                        end
                    end
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "ExtendedSessionLoadPost",
                group = augroup,
                callback = function()
                    for _, win in pairs(vim.api.nvim_list_wins()) do
                        local loaded = sessions.loaded.win(win).buffer_history
                        if not loaded then
                            vim.w[win].buffer_history = {
                                vim.api.nvim_win_get_buf(win),
                            }
                            vim.w[win].buffer_history_index = 0
                            return
                        end

                        local corrected_history = {}
                        for _, old_id in pairs(loaded.buffer_history) do
                            table.insert(corrected_history, sessions.find_new_bufid(old_id))
                        end
                        vim.w[win].buffer_history = corrected_history
                        vim.w[win].buffer_history_index = loaded.buffer_history_index
                    end
                end,
            })
        end,
    },
}
