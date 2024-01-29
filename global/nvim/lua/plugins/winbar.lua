return {
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-web-devicons",
		},
		config = function()
			require("barbecue").setup({
				attach_navic = false,
				theme = {
					normal = { underline = true, sp = "lightgray" },
				},
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.server_capabilities["documentSymbolProvider"] then
						require("nvim-navic").attach(client, bufnr)
					end
				end,
			})
		end,
	},
}
