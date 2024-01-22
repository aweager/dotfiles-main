vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("AweLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings (after lsp attaches)
		-- see `:help vim.lsp.*` for docs on functions
		vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, {
			buffer = ev.buf,
			desc = "Go to {d}efinition",
		})
		vim.keymap.set("n", "<leader>u", vim.lsp.buf.references, {
			buffer = ev.buf,
			desc = "Find {u}ses",
		})
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {
			buffer = ev.buf,
			desc = "{r}ename symbol",
		})
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action, {
			buffer = ev.buf,
			desc = "Apply {f}ix (via code_action)",
		})
	end,
})

return {
	"williamboman/mason.nvim",
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler
					require("lspconfig")[server_name].setup({
						capabilities = default_capabilities,
					})
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
		},
	},
}
