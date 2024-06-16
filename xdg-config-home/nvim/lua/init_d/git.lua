vim.keymap.set("n", "<m-C>", function()
    -- TODO use lua? could copy git link...?
    vim.cmd("let @+ = substitute(expand('%:p'), '^' . g:root_dir . '/', '', '')")
end, {
    silent = true,
    desc = "Copy the root-relative path of the current buffer",
})

vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"

local augroup = vim.api.nvim_create_augroup("AweGit", {})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = {
        "gitcommit",
        "gitrebase",
        "gitconfig",
    },
    callback = function()
        vim.o.bufhidden = "delete"
    end,
})
