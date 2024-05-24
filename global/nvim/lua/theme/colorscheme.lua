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

	local listchars = require("themeconfig").listchars
	vim.api.nvim_set_hl(0, "NonText", listchars.non_text)
	vim.api.nvim_set_hl(0, "Whitespace", listchars.whitespace)
end

return { colorscheme }
