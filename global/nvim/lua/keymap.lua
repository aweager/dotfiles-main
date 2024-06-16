vim.keymap.set("n", "<leader>z", function()
    vim.cmd.nohlsearch()
end, {
    silent = true,
    desc = "Turn off search result highlighting",
})
