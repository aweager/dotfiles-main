local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
            == nil
end

return {
    -- Formatters
    "stevearc/conform.nvim",
    -- Linters
    "mfussenegger/nvim-lint",
    -- Snippets
    "L3MON4D3/LuaSnip",
    {
        -- Completions
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            vim.diagnostic.config({
                virtual_lines = {
                    current_line = true,
                },
            })
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {},
                mapping = cmp.mapping.preset.insert({
                    ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
                    ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
                    ["<c-e>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<c-y>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),

                    ["<c-space>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.close()
                        else
                            cmp.complete()
                        end
                    end, { "i", "c" }),

                    ["<tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<s-tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "lazydev" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })

            -- use buffer source for '/' and '?'
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':'
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },
    {
        -- Package manager, ideally totally unused, but sometimes easiest way
        -- to install packages
        "williamboman/mason.nvim",
        opts = {
            PATH = "append",
        },
    },
    {
        -- :Navbuddy for navigating large files using treesitter
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
    },
    {
        -- neovim lua library symbols
        "folke/lazydev.nvim",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library" },
            },
        },
    },
    {
        -- Symbols for vim.uv
        "Bilal2453/luvit-meta",
        lazy = true,
    },
    {
        -- Community configs for LSP configurations
        "neovim/nvim-lspconfig",
        dependencies = {
            "SmiteshP/nvim-navbuddy",
            "hrsh7th/cmp-nvim-lsp",
        },
    },
    {
        dir = vim.env.DUMB_CLONE_HOME .. "/ide-config.nvim",
        name = "ide-config",
        main = "ide-config",
        opts = require("langs"),
    },
}
