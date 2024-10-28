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

local config_dirs = vim.fn.stdpath("config_dirs")
---@cast config_dirs string[]

---Require all packages under a mod prefix from config dirs
---@param mod_prefix string
local function require_all(mod_prefix)
    local paths = { vim.fn.stdpath("config") .. "/lua/" .. mod_prefix }
    for _, config_dir in ipairs(config_dirs) do
        table.insert(paths, config_dir .. "/lua/" .. mod_prefix)
    end

    for _, mod_dir in ipairs(paths) do
        local pattern = mod_dir .. "/*.lua"
        for _, file in ipairs(vim.fn.glob(pattern, false, true)) do
            require(mod_prefix .. "." .. vim.fn.fnamemodify(file, ":t:r"))
        end
    end
end

require_all("before_plugins")

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

-- Need to re-add config_dirs because lazy removes them
for _, directory in ipairs(config_dirs) do
    vim.opt.rtp:prepend(directory)
end

require_all("init_d")
