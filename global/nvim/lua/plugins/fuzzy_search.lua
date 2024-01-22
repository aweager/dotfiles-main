-- fuzzy-finding from the root directory
local fzf = { "junegunn/fzf.vim" }

fzf.dependencies = { "junegunn/fzf" }

fzf.config = function()
	local root_dir_is_git_repo = vim.loop.fs_stat(vim.g.root_dir .. "/.git")
	if root_dir_is_git_repo then
		vim.keymap.set("n", "<leader>o", function()
			vim.fn["fzf#vim#gitfiles"]("", {
				dir = vim.g.root_dir,
			})
		end, {
			silent = true,
			desc = "Fuzzy find a file",
		})
	else
		vim.keymap.set("n", "<leader>o", function()
			vim.cmd.Files(vim.g.root_dir)
			vim.cmd.startinsert()
		end, {
			silent = true,
			desc = "Fuzzy find a file",
		})
	end

	vim.keymap.set("n", "<leader>/", function()
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
