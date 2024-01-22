-- fuzzy-finding from the root directory
local fzf = { "junegunn/fzf.vim" }

fzf.dependencies = { "junegunn/fzf" }

fzf.config = function()
	local path = vim.g.root_dir .. "/.git"
	local ok = vim.loop.fs_stat(path)
	if ok then
		vim.keymap.set({ "n", "i", "t" }, "<m-p>", function()
			vim.cmd.GFiles()
			vim.cmd.startinsert()
		end, {
			silent = true,
			desc = "Fuzzy find a file",
		})
		vim.keymap.set("v", "<m-p>", function()
			require("localmode").save_mode("v")
			vim.cmd.GFiles()
			vim.cmd.startinsert()
		end, {
			silent = true,
			desc = "Fuzzy find a file",
		})
	else
		vim.keymap.set({ "n", "i", "t" }, "<m-p>", function()
			vim.cmd.Files(vim.g.root_dir)
			vim.cmd.startinsert()
		end, {
			silent = true,
			desc = "Fuzzy find a file",
		})
		vim.keymap.set("v", "<m-p>", function()
			require("localmode").save_mode("v")
			vim.cmd.Files(vim.g.root_dir)
			vim.cmd.startinsert()
		end, {
			silent = true,
			desc = "Fuzzy find a file",
		})
	end

	vim.keymap.set({ "n", "i", "t" }, "<m-/>", function()
		vim.fn["fzf#vim#ag"]("", {
			dir = vim.g.root_dir,
		})
		vim.cmd.startinsert()
	end, {
		silent = true,
		desc = "Fuzzy search in files",
	})
	vim.keymap.set("v", "<m-/>", function()
		require("localmode").save_mode("v")
		vim.fn["fzf#vim#ag"]("", {
			dir = vim.g.root_dir,
		})
		vim.cmd.startinsert()
	end, {
		silent = true,
		desc = "Fuzzy search in files",
	})
end

return { fzf }
