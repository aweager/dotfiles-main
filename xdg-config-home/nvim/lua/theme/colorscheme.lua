---@diagnostic disable: assign-type-mismatch, param-type-mismatch
local colorscheme = { "Mofiqul/vscode.nvim" }

colorscheme.dependencies = { "nvim-web-devicons" }
colorscheme.priority = 1000

colorscheme.config = function()
    local themeconfig = require("init_d.themeconfig")

    local vscode = require("vscode")
    local c = require("vscode.colors").get_colors()
    vscode.setup({
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = true,

        group_overrides = {
            NonText = themeconfig.listchars.non_text,
            Whitespace = themeconfig.listchars.whitespace,

            WinSeparator = themeconfig.windows.separator,

            DiagnosticHint = themeconfig.hints.diagnostic_hint,
            DiagnosticInfo = themeconfig.hints.diagnostic_info,
            LspInlayHint = themeconfig.hints.inlay_hint,

            TreesitterContext = {
                bg = themeconfig.context.bg,
            },
            TreesitterContextBottom = {
                bg = themeconfig.context.bg,
                sp = themeconfig.context.underline_color,
                underdashed = true,
            },
            TreesitterContextLineNumber = {
                fg = c.vscLineNumber,
                bg = themeconfig.context.bg,
            },
            TreesitterContextLineNumberBottom = {
                fg = c.vscLineNumber,
                bg = themeconfig.context.bg,
                sp = themeconfig.context.underline_color,
                underdashed = true,
            },
        },
    })
    vscode.load()
end

return { colorscheme }
