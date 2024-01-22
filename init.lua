vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.root_dir = vim.fn.getcwd()

vim.cmd.source("~/.vimrc")

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

local awe_config = vim.fn.stdpath("config")
vim.opt.rtp:append(awe_config .. "/global/nvim")
vim.opt.rtp:append(awe_config .. "/os/nvim")
vim.opt.rtp:append(awe_config .. "/org/nvim")
vim.opt.rtp:append(awe_config .. "/machine/nvim")

require("lazy").setup({
	spec = { import = "plugins" },
	change_detection = {
		enabled = false,
		notify = false,
	},
})

vim.cmd("runtime! global/nvim/lua/*.lua")
vim.cmd("runtime! os/nvim/lua/*.lua")
vim.cmd("runtime! org/nvim/lua/*.lua")
vim.cmd("runtime! machine/nvim/lua/*.lua")
