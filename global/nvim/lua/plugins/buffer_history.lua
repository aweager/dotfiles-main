-- window-local buffer history
return {
	{
		"dhruvasagar/vim-buffer-history",
		config = function()
			local opts = { silent = true }
			vim.keymap.set("n", "<c-p>", vim.cmd.BufferHistoryBack(), opts)
			vim.keymap.set("n", "<c-n>", vim.cmd.BufferHistoryForward(), opts)
		end,
	},
}
