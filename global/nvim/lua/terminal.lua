vim.keymap.set("t", "<m-C>", "<c-\\><c-n>")
vim.o.scrollback = 100000

local get_terminal_window = function(bufnr)
	for _, window in pairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(window) == bufnr then
			return window
		end
	end
	return nil
end

local save_terminal = function(bufnr)
	local window = get_terminal_window(bufnr)
	if window == nil then
		return
	end

	local terminal_data_dir = vim.fn.stdpath("data") .. "/terminal_data/" .. vim.b[bufnr].terminal_job_pid
	-- TODO use vim.loop
	os.execute("mkdir -p " .. terminal_data_dir)

	local sessions = require("sessions")
	local to_save = sessions.to_save.buf(bufnr)

	local tabpage = vim.api.nvim_win_get_tabpage(window)
	local winnr = vim.api.nvim_win_get_number(window)
	to_save.directory = vim.fn.getcwd(winnr, tabpage)

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, vim.o.scrollback, false)
	local filename = terminal_data_dir .. "/contents.txt"
	local file = vim.loop.fs_open(filename, "w", 1)
	if file == nil then
		error("Cannot open file " .. filename)
		return
	end

	for _, line in pairs(lines) do
		vim.loop.fs_write(file, line + "\n")
	end
	vim.loop.fs_close(file)

	to_save.contents_file = filename
end

local restore_terminal = function(bufnr)
	local sessions = require("sessions")
	local terminal_data = sessions.loaded.buf(bufnr)

	local restore_cmd = ""

	if terminal_data.directory ~= nil then
		restore_cmd = restore_cmd .. 'cd "' .. terminal_data.directory .. '"; '
	end

	if terminal_data.contents_file ~= nil then
		restore_cmd = restore_cmd .. 'cat "' .. terminal_data.contents_file .. '"; '
	end

	if restore_cmd ~= "" then
		restore_cmd = restore_cmd .. 'echo "\n-- RESTORED --"'
		vim.api.nvim_chan_send(vim.b[bufnr].terminal_job_id, restore_cmd .. "\n")
	end
end

local configure_terminal = function(bufnr)
	vim.keymap.set("n", "<enter>", "i", { buffer = bufnr })
	local buffer_augroup = vim.api.nvim_create_augroup("AweTerminalBuf" .. bufnr, {})
	vim.api.nvim_create_autocmd("BufHidden", {
		group = buffer_augroup,
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

vim.api.nvim_create_autocmd("User", {
	pattern = "AweSessionWritePre",
	group = augroup,
	callback = function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buftype == "terminal" then
				save_terminal(buf)
			end
		end
	end,
})

local session_loaded = false
vim.api.nvim_create_autocmd("SessionLoadPost", {
	group = augroup,
	callback = function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buftype == "terminal" then
				restore_terminal(buf)
				configure_terminal(buf)
			end
		end
		session_loaded = true
		return true
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

return {
	get_terminal_window = get_terminal_window,
}
