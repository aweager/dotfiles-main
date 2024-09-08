-- vim:foldmethod=marker

local tabmux = require("init_d.tabmux")
local localmode = require("localmode")

local supported_modes = { "n", "i", "t", "v" }

-- pin tab {{{

vim.keymap.set(supported_modes, "<m-p>", function()
    tabmux.toggle_pin()
end, {
    silent = true,
    desc = "{p}in / unpin the current tabpage",
})

-- }}}

-- arranging tabs {{{

vim.keymap.set(supported_modes, "<m-H>", function()
    tabmux.move_left()
end, {
    silent = true,
    desc = "Move the current tabpage left by one",
})

vim.keymap.set(supported_modes, "<m-L>", function()
    tabmux.move_right()
end, {
    silent = true,
    desc = "Move the current tabpage right by one",
})

-- }}}

-- move, jump, close, or open tabs {{{

local mover_keymap = {
    h = {
        callback = vim.cmd.tabprevious,
        desc = "Go left one tabpage",
    },
    l = {
        callback = vim.cmd.tabnext,
        desc = "Go right one tabpage",
    },
    w = {
        callback = tabmux.close_tab,
        desc = "Close the current tabpage",
    },
    t = {
        callback = function()
            vim.cmd.tabnew()
            vim.cmd.terminal()
            vim.cmd.startinsert()
        end,
        desc = "Open a new terminal in the cwd in a new tabpage",
    },
    ["0"] = {
        callback = vim.cmd.tablast,
        desc = "Jump to the last tabpage",
    },
}

for i = 1, 9 do
    mover_keymap["" .. i] = {
        callback = function()
            vim.cmd.tabnext(i)
        end,
        desc = "Jump to tabpage #" .. i,
    }
end

for key, config in pairs(mover_keymap) do
    for _, mode in pairs(supported_modes) do
        vim.keymap.set(mode, "<m-" .. key .. ">", function()
            localmode.execute_move(mode, config.callback)
        end, {
            silent = true,
            desc = config.desc,
        })
    end
end

-- }}}
