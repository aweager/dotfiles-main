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
                        if vim.w[win].buffer_history then
                            sessions.to_save.win(win).buffer_history = {
                                buffer_history = vim.w[win].buffer_history,
                                buffer_history_index = vim.w[win].buffer_history_index,
                            }
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
                        local corrected_ind = loaded.buffer_history_index
                        for ind, old_id in ipairs(loaded.buffer_history) do
                            local new_id = sessions.find_new_bufid(old_id)
                            if new_id ~= nil then
                                table.insert(corrected_history, new_id)
                            elseif ind < loaded.buffer_history_index then
                                corrected_ind = corrected_ind - 1
                            elseif ind == loaded.buffer_history_index then
                                -- The buffer that was in this window was not restored
                                corrected_ind = nil
                                break
                            end
                        end

                        if corrected_ind ~= nil then
                            vim.w[win].buffer_history = corrected_history
                            vim.w[win].buffer_history_index = loaded.buffer_history_index
                        else
                            vim.w[win].buffer_history = {
                                vim.api.nvim_win_get_buf(win),
                            }
                            vim.w[win].buffer_history_index = 0
                        end
                    end
                end,
            })
        end,
    },
}
