vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("AweLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings (after lsp attaches)
		-- see `:help vim.lsp.*` for docs on functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<m-;>", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<m-:>", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action, opts)
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
						-- on_attach = function(client, bufnr)
						-- 	if client.server_capabilities["documentSymbolProvider"] then
						-- 		require("nvim-navic").attach(client, bufnr)
						-- 	end
						-- end,
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
	{
		"kosayoda/nvim-lightbulb",
		opts = {
			autocmd = { enabled = true },
		},
	},
}
