vim.api.nvim_create_user_command("ClearHiddenBuffers", function(opts)
    local delete_modified = opts.bang
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local modified = vim.bo[buf].modified
        local hidden = vim.fn.getbufinfo(buf)[1].hidden == 1
        local valid = vim.api.nvim_buf_is_valid(buf)
        local should_delete = (delete_modified or not modified) and hidden and valid

        if should_delete then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end, {
    desc = "Clear out hidden buffers",
    bang = true,
})
