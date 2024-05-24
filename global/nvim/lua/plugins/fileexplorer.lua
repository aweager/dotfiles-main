-- file exporer & directory viewer
local tree = { "nvim-tree/nvim-tree.lua" }

tree.dependencies = { "nvim-tree/nvim-web-devicons" }

tree.config = function()
	require("nvim-tree").setup()
	vim.keymap.set({ "n", "t" }, "<m-space>", function()
		vim.cmd.NvimTreeToggle(vim.g.root_dir)
	end)
end

return { tree }
