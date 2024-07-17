return {
    {
        "mhartington/formatter.nvim",
        dependencies = { "ide-config" },
        config = function()
            local by_ft = {
                ["*"] = {
                    require("formatter.filetypes.any").remove_trailing_whitespace,
                },
            }

            for ft, configs in pairs(require("ide-config").formatters_by_filetype()) do
                by_ft[ft] = {}
                for _, config in pairs(configs) do
                    local success, ft_options = pcall(require, "formatter.filetypes." .. ft)
                    if success then
                        table.insert(by_ft[ft], ft_options[config.name])
                    end
                end
            end

            require("formatter").setup({
                log_level = vim.log.levels.WARN,
                filetype = by_ft,
            })
        end,
    },
}
