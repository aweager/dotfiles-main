-- Only proceed if there is a session file
if vim.env.NVIM_SESSION_FILE == nil then
	return
end

vim.g.session_file = vim.env.NVIM_SESSION_FILE
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"

vim.g.AWE_SESSION_EXTRAS = {}

local augroup = vim.api.nvim_create_augroup("AweSessions", {})
vim.api.nvim_create_autocmd("VimLeave", {
	group = augroup,
	callback = function()
		vim.cmd("mksession! " .. vim.g.session_file)
	end,
})
