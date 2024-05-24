vim.keymap.set("n", "<leader>x", function()
    vim.cmd.cclose()
end, {
    silent = true,
    desc = "Close the quick list window (cclose)",
})
