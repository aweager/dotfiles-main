-- plugins that help with config files
return {
    {
        "aweager/nvim-reg",
        main = "reg",
        config = function()
            require("reg").setup()
        end,
    },
}
