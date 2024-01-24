vim.keymap.set("t", "<m-C>", "<c-\\><c-n>")

local configure_terminal = function(bufnr)
	vim.opt_local.number = false
	vim.keymap.set("n", "<enter>", "i", { buffer = bufnr })
	vim.api.nvim_create_autocmd("BufHidden", {
		buffer = bufnr,
		callback = function()
			vim.defer_fn(function()
				vim.api.nvim_buf_delete(bufnr, { force = true })
			end, 100)
		end,
	})
end

local group = vim.api.nvim_create_augroup("AweTerminal", {})

vim.api.nvim_create_autocmd("SessionLoadPost", {
	group = group,
	callback = function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buftype == "terminal" then
				configure_terminal(buf)
			end
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	callback = function()
		configure_terminal(vim.api.nvim_get_current_buf())
		vim.cmd.startinsert()
	end,
})

vim.api.nvim_create_autocmd("TermEnter", {
	group = group,
	callback = function()
		vim.cmd.NoMatchParen()
		vim.opt.hlsearch = false
	end,
})

vim.api.nvim_create_autocmd("TermLeave", {
	group = group,
	callback = function()
		vim.cmd.DoMatchParen()
		vim.opt.hlsearch = true
	end,
})

return {
	pid_to_bufnr = function(pid)
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			if vim.b[buf].terminal_job_pid == pid then
				return buf
			end
		end
		return -1
	end,
}
