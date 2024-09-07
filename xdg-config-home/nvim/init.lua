vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.root_dir = vim.fn.getcwd()

-- source vim config
vim.cmd.source(vim.env.XDG_CONFIG_HOME .. "/vim/vimrc")

-- load lazy.nvim
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

-- source all init_d packages
local function require_all_init_d(directory)
    local pattern = directory .. "/lua/init_d/*.lua"
    for _, file in ipairs(vim.fn.glob(pattern, false, true)) do
        require("init_d." .. vim.fn.fnamemodify(file, ":t:r"))
    end
end

require_all_init_d(vim.fn.stdpath("config"))
for _, directory in ipairs(vim.fn.stdpath("config_dirs")) do
    vim.opt.rtp:prepend(directory)
    require_all_init_d(directory)
end
