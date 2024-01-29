vim.o.termguicolors = true

local devicons = { "nvim-tree/nvim-web-devicons" }

local colorscheme = { "Mofiqul/vscode.nvim" }
colorscheme.dependencies = { "nvim-web-devicons" }
colorscheme.priority = 1000
colorscheme.config = function()
	local vscode = require("vscode")
	vscode.setup({
		italic_comments = true,
		disable_nvimtree_bg = true,
	})
	vscode.load()

	vim.api.nvim_set_hl(0, "NonText", {
		bg = "darkgreen",
		ctermbg = "darkgreen",
	})
	vim.api.nvim_set_hl(0, "Whitespace", {
		fg = "#363636",
		ctermfg = "darkgray",
	})
end

local statusline = { "nvim-lualine/lualine.nvim" }
statusline.dependencies = { "nvim-web-devicons" }
statusline.opts = {
	theme = "vscode",
}

return { devicons, colorscheme, statusline }
