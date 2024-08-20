return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                PATH = "append",
            })
        end,
    },
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
    },
    {
        "folke/lazydev.nvim",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library" },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "SmiteshP/nvim-navbuddy",
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "ide-config",
        },
        config = function()
            local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lsps = require("ide-config").lsps_by_name()
            local lspconfig = require("lspconfig")

            for name, lsp in pairs(lsps) do
                local opts = lsp.lspconfig
                opts.capabilities = default_capabilities
                lspconfig[name].setup(opts)
            end
        end,
    },
}
