vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.root_dir = vim.fn.getcwd()

vim.cmd.source("~/.vimrc")
local require_all = function(directory)
	local path = vim.fn.stdpath("config") .. "/" .. directory .. "/nvim"
	vim.opt.rtp:append(path)

	local pattern = path .. "/lua/*.lua"
	for _, file in ipairs(vim.fn.glob(pattern, false, true)) do
		require(vim.fn.fnamemodify(file, ":t:r"))
	end
end

require_all("global")
require_all("os")
require_all("org")
require_all("machine")
require("sessions")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "theme" },
	},
	change_detection = {
		enabled = false,
		notify = false,
	},
})
