local augroup = vim.api.nvim_create_augroup("AweHighlighter", {})

vim.o.updatetime = 1000

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            local doc_highlight_group = vim.api.nvim_create_augroup("lsp_document_highlight", {
                clear = false,
            })
            vim.api.nvim_clear_autocmds({
                group = doc_highlight_group,
                buffer = buf,
            })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = doc_highlight_group,
                buffer = buf,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = doc_highlight_group,
                buffer = buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
