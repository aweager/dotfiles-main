local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    window = {},
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ['<C-e>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ['<C-y>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for '/' and '?'
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    source = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
