-- window-local buffer history

-- TODO this should be an autocmd
-- initialize buffer history for already-opened buffers
for index, win in pairs(vim.api.nvim_list_wins()) do
	local buf = vim.api.nvim_win_get_buf(win)
	vim.w[win].buffer_history = { buf }
	vim.w[win].buffer_history_index = 0
end

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
