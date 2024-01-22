vim.keymap.set("n", "<m-C>", function()
	-- TODO use lua? could copy git link...?
	vim.cmd("let @+ = substitute(expand('%:p'), '^' . g:root_dir . '/', '', '')")
end, {
	silent = true,
	desc = "Copy the root-relative path of the current buffer",
})
