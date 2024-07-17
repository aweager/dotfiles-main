return {
    {
        "mfussenegger/nvim-lint",
        dependencies = { "ide-config" },
        config = function()
            local by_ft = {}
            for ft, configs in pairs(require("ide-config").linters_by_filetype()) do
                by_ft[ft] = {}
                for _, config in pairs(configs) do
                    table.insert(by_ft[ft], config.name)
                end
            end

            require("lint").linters_by_ft = by_ft
        end,
    },
}
