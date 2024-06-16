vim.keymap.set("n", "<leader>x", function()
    vim.cmd.cclose()
end, {
    silent = true,
    desc = "Close the quick list window (cclose)",
})

local localmode = require("init_d.localmode")
local ctrl_w_mappings = {
    "w",
    "j",
    "k",
    "h",
    "l",
    "s",
    "v",
}

for _, c in pairs(ctrl_w_mappings) do
    local ctrl_c = "<c-" .. c .. ">"
    local normal_command = '"normal \\<c-w>\\' .. ctrl_c .. '"'
    vim.keymap.set("t", "<c-w>" .. ctrl_c, function()
        localmode.execute_move("t", function()
            vim.cmd.execute(normal_command)
        end)
    end)
    vim.keymap.set("t", "<c-w>" .. c, function()
        localmode.execute_move("t", function()
            vim.cmd.execute(normal_command)
        end)
    end)
end
