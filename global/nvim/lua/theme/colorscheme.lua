local colorscheme = { "Mofiqul/vscode.nvim" }

colorscheme.dependencies = { "nvim-web-devicons" }
colorscheme.priority = 1000

colorscheme.config = function()
    local vscode = require("vscode")
    vscode.setup({
        italic_comments = true,
        disable_nvimtree_bg = true,
    })
    vscode.load()

    local themeconfig = require("themeconfig")
    vim.api.nvim_set_hl(0, "NonText", themeconfig.listchars.non_text)
    vim.api.nvim_set_hl(0, "Whitespace", themeconfig.listchars.whitespace)
    vim.api.nvim_set_hl(0, "WinSeparator", themeconfig.windows.separator)
end

return { colorscheme }
