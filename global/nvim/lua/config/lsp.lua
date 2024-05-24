require("mason").setup()
require("mason-lspconfig").setup()

local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup_handlers({
	function(server_name) -- default handler
		require("lspconfig")[server_name].setup({
			capabilities = default_capabilities,
		})
	end,
})

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

require("nvim-lightbulb").setup({
	autocmd = { enabled = true },
})
