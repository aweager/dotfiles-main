return {
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-web-devicons",
        },
        config = function()
            local theme = require("init_d.themeconfig")
            local mux = require("mux.api")
            require("barbecue").setup({
                attach_navic = false,
                show_dirname = false,
                show_basename = false,
                lead_custom_section = function(bufnr, winnr)
                    local info = mux.resolve_info("w:" .. winnr)
                    return {
                        { " " },
                        {
                            info.icon,
                            theme.winbar.get_icon_hl(info, winnr),
                        },
                        { " " },
                        {
                            info.title,
                            theme.winbar.get_title_hl(info),
                        },
                        { "  " },
                    }
                end,
                theme = {
                    normal = {
                        underline = true,
                        sp = theme.winbar.underline_color,
                    },
                },
                symbols = {
                    separator = "",
                },
            })

            local augroup = vim.api.nvim_create_augroup("AweWinbar", {})
            vim.api.nvim_create_autocmd("BufModifiedSet", {
                group = augroup,
                callback = function(args)
                    for _, winnr in pairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(winnr) == args.buf then
                            require("barbecue.ui").update(winnr)
                        end
                    end
                end,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = augroup,
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.server_capabilities["documentSymbolProvider"] then
                        require("nvim-navic").attach(client, bufnr)
                    end
                end,
            })
        end,
    },
}
