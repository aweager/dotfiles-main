return {
    -- git integrations
    "tpope/vim-fugitive",
    -- vscode-like git diff
    {
        "esmuellert/vscode-diff.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "CodeDiff",
    },
}
