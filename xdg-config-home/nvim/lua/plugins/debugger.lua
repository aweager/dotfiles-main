return {
    -- Golang plugin
    {
        "leoluz/nvim-dap-go",
        config = function()
            require("dap-go").setup()
        end,
    },
    -- C / C++ / Rust plugin
    {
        "julianolf/nvim-dap-lldb",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {},
    },
    -- DAP framework
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "leoluz/nvim-dap-go",
            "ide-config",
        },
        config = function()
            -- Some better UI on the icon tray
            vim.fn.sign_define(
                "DapBreakpoint",
                { text = "🛑", texthl = "", linehl = "", numhl = "" }
            )
        end,
    },
    -- UI
    {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {
            winbar = {
                default_section = "repl",
                controls = {
                    enabled = true,
                },
            },
            auto_toggle = true,
        },
    },
}
