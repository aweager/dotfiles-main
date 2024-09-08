-- fuzzy-finding from the root directory
local fzf = { "junegunn/fzf.vim" }

fzf.dependencies = { "junegunn/fzf" }

fzf.config = function()
    local root_dir_is_git_repo = vim.loop.fs_stat(vim.g.root_dir .. "/.git")
    if root_dir_is_git_repo then
        vim.keymap.set("n", "<leader>o", function()
            vim.fn["fzf#vim#gitfiles"]("--cached --others --exclude-standard", {
                dir = vim.g.root_dir,
            })
        end, {
            silent = true,
            desc = "{o}pen a file",
        })
    else
        vim.keymap.set("n", "<leader>o", function()
            vim.cmd.Files(vim.g.root_dir)
            vim.cmd.startinsert()
        end, {
            silent = true,
            desc = "{o}pen a file",
        })
    end

    vim.keymap.set("n", "<leader>/", function()
        vim.fn["fzf#vim#ag"]("", {
            dir = vim.g.root_dir,
        })
        vim.cmd.startinsert()
    end, {
        silent = true,
        desc = "Search within files",
    })

    vim.keymap.set("n", "<leader>b", function()
        vim.cmd.Buffers()
    end, {
        silent = true,
        desc = "Switch to a {b}uffer",
    })
end

return { fzf }
