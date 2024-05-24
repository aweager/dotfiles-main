-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

vim.keymap.set("n", "<m-space>", ":NvimTreeToggle " .. vim.g.root_dir .. "<CR>")
