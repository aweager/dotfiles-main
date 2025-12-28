return {
    -- Golang plugin
    {
        "fredrikaverpil/neotest-golang",
    },
    -- Gtest pugin
    {
        "alfaix/neotest-gtest",
    },
    -- Testing framework
    {
        "nvim-neotest/neotest",
        dependencies = {
            "fredrikaverpil/neotest-golang",
            "alfaix/neotest-gtest",
            "ide-config",

            -- Upstream dependencies
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-golang"),
                    require("neotest-gtest").setup({}),
                },
            })
        end,
    },
}
