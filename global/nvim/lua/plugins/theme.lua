vim.o.termguicolors = true

local devicons = { "nvim-tree/nvim-web-devicons" }
devicons.opts = {
	color_icons = true,
	default = true,
	strict = true,
}

local colorscheme = { "Mofiqul/vscode.nvim" }
colorscheme.dependencies = { "nvim-tree/nvim-web-devicons" }
colorscheme.priority = 1000
colorscheme.config = function()
	local vscode = require("vscode")
	vscode.setup({
		italic_comments = true,
		disable_nvimtree_bg = true,
	})
	vscode.load()

	vim.cmd("highlight NonText ctermbg=darkgreen guibg=darkgreen")
	vim.cmd("highlight Whitespace ctermfg=darkgray guifg=#363636")
end

local statusline = { "nvim-lualine/lualine.nvim" }
statusline.dependencies = { "nvim-tree/nvim-web-devicons" }
statusline.opts = {
	theme = "vscode",
}

return { devicons, colorscheme, statusline }
