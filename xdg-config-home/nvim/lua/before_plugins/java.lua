local runtime_keys = vim.split(vim.env.JAVA_RUNTIMES or "", ":")
local java_runtimes = {}
for _, runtime_key in pairs(runtime_keys) do
    table.insert(java_runtimes, {
        name = vim.env["JAVA_RUNTIME_NAME_" .. runtime_key],
        path = vim.env["JAVA_RUNTIME_PATH_" .. runtime_key],
    })
end

table.insert(require("langs"), {
    langs = {
        {
            name = "java",
            filetypes = { "java" },
            lsp = "jdtls",
        },
    },
    lsps = {
        {
            name = "jdtls",
            lspconfig = {
                settings = {
                    java = {
                        configuration = {
                            runtimes = java_runtimes,
                        },
                    },
                },
            },
        },
    },
})
