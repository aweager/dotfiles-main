require("formatter").setup({
	logging = false,
	log_level = vim.log.levels.WARN,

	-- All formatter configurations are opt-in
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},

		python = {
			require("formatter.filetypes.python").black,
		},

		zsh = {
			require("formatter.filetypes.zsh").beautysh,
		},

		cpp = {
			require("formatter.filetypes.cpp").clangformat,
		},

		-- Applies to all filetypes
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

require("lint").linters_by_ft = {
	markdown = { "alex" },
	python = { "mypy" },
}
