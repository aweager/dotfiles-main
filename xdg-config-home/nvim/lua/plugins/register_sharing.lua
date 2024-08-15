-- plugins that help with config files
return {
    {
        "aweager/nvim-reg",
        main = "reg",
        enabled = false,
        config = function()
            require("reg").setup()
        end,
    },
}
