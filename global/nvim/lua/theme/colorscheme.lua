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

    -- TODO: unify this list somehow with wezterm, which is where i got it from
    local colors = {
        "#000000",
        "#cc5555",
        "#55cc55",
        "#cdcd55",
        "#5455cb",
        "#cc55cc",
        "#7acaca",
        "#cccccc",

        "#555555",
        "#ff5555",
        "#55ff55",
        "#ffff55",
        "#5555ff",
        "#ff55ff",
        "#55ffff",
        "#ffffff",
    }

    for index, color in pairs(colors) do
        vim.g["terminal_color_" .. (index - 1)] = color
    end
end

return { colorscheme }
