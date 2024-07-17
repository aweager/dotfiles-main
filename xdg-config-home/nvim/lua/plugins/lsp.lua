vim.lsp.inlay_hint.enable()

-- TODO in lua
vim.cmd([[
    highlight DiagnositHint ctermfg=darkgray guifg=darkgray
    highlight DiagnositInfo ctermfg=darkgray guifg=darkgray
]])

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
        "neovim/nvim-lspconfig",
        dependencies = {
            "SmiteshP/nvim-navbuddy",
            "williamboman/mason.nvim",
            "folke/neodev.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "ide-config",
        },
        config = function()
            local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lsps = require("ide-config").lsps_by_name()
            local lspconfig = require("lspconfig")

            require("neodev").setup({
                override = function(root_dir, library)
                    library.enabled = true
                    library.plugins = true
                end,
            })

            for name, lsp in pairs(lsps) do
                local opts = lsp.lspconfig
                opts.capabilities = default_capabilities
                lspconfig[name].setup(opts)
            end
        end,
    },
}
