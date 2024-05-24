vim.keymap.set("t", "<m-C>", "<c-\\><c-n>")

local session_loaded = false

local configure_terminal = function(bufnr)
	vim.keymap.set("n", "<enter>", "i", { buffer = bufnr })
	vim.api.nvim_create_autocmd("BufHidden", {
		buffer = bufnr,
		callback = function(ev)
			local to_delete = ev.buf
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(to_delete) then
					vim.api.nvim_buf_delete(to_delete, { force = true })
				end
			end, 100)
			return true
		end,
	})
end

local augroup = vim.api.nvim_create_augroup("AweTerminal", {})

vim.api.nvim_create_autocmd("SessionLoadPost", {
	group = augroup,
	callback = function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buftype == "terminal" then
				configure_terminal(buf)
			end
		end
		session_loaded = true
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		if not vim.g.session_file or session_loaded then
			configure_terminal(vim.api.nvim_get_current_buf())
			vim.cmd.startinsert()
		end
	end,
})

vim.api.nvim_create_autocmd("TermEnter", {
	group = augroup,
	callback = function()
		vim.cmd.NoMatchParen()
		vim.opt.hlsearch = false
		vim.opt_local.number = false
	end,
})

vim.api.nvim_create_autocmd("TermLeave", {
	group = augroup,
	callback = function()
		vim.cmd.DoMatchParen()
		vim.opt.hlsearch = true
		vim.opt_local.number = true
	end,
})
