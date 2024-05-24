-- vim:foldmethod=marker

local function save_visual_mode()
    require("localmode").save_mode("v")
end

local tabmux = require("tabmux")

-- pin tab {{{

vim.keymap.set({ "n", "i", "t", "v" }, "<m-p>", function()
    tabmux.toggle_pin()
end, {
    silent = true,
    desc = "{p}in / unpin the current tabpage",
})

-- }}}

-- switching between tabs {{{

vim.keymap.set({ "n", "i", "t" }, "<m-h>", function()
    vim.cmd.tabprevious()
end, {
    silent = true,
    desc = "Go left one tabpage",
})
vim.keymap.set("v", "<m-h>", function()
    save_visual_mode()
    vim.cmd.tabprevious()
end, {
    silent = true,
    desc = "Go left one tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-l>", function()
    vim.cmd.tabnext()
end, {
    silent = true,
    desc = "Go right one tabpage",
})
vim.keymap.set("v", "<m-l>", function()
    save_visual_mode()
    vim.cmd.tabnext()
end, {
    silent = true,
    desc = "Go right one tabpage",
})

-- }}}

-- jumping to tabs {{{

vim.keymap.set({ "n", "i", "t" }, "<m-1>", function()
    vim.cmd.tabfirst()
end, {
    silent = true,
    desc = "Jump to the 1st tabpage",
})
vim.keymap.set("v", "<m-1>", function()
    save_visual_mode()
    vim.cmd.tabfirst()
end, {
    silent = true,
    desc = "Jump to the 1st tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-2>", function()
    vim.cmd.tabnext(2)
end, {
    silent = true,
    desc = "Jump to the 2nd tabpage",
})
vim.keymap.set("v", "<m-2>", function()
    save_visual_mode()
    vim.cmd.tabnext(2)
end, {
    silent = true,
    desc = "Jump to the 2nd tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-3>", function()
    vim.cmd.tabnext(3)
end, {
    silent = true,
    desc = "Jump to the 3rd tabpage",
})
vim.keymap.set("v", "<m-3>", function()
    save_visual_mode()
    vim.cmd.tabnext(3)
end, {
    silent = true,
    desc = "Jump to the 3rd tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-4>", function()
    vim.cmd.tabnext(4)
end, {
    silent = true,
    desc = "Jump to the 4th tabpage",
})
vim.keymap.set("v", "<m-4>", function()
    save_visual_mode()
    vim.cmd.tabnext(4)
end, {
    silent = true,
    desc = "Jump to the 4th tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-5>", function()
    vim.cmd.tabnext(5)
end, {
    silent = true,
    desc = "Jump to the 5th tabpage",
})
vim.keymap.set("v", "<m-5>", function()
    save_visual_mode()
    vim.cmd.tabnext(5)
end, {
    silent = true,
    desc = "Jump to the 5th tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-6>", function()
    vim.cmd.tabnext(6)
end, {
    silent = true,
    desc = "Jump to the 6th tabpage",
})
vim.keymap.set("v", "<m-6>", function()
    save_visual_mode()
    vim.cmd.tabnext(6)
end, {
    silent = true,
    desc = "Jump to the 6th tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-7>", function()
    vim.cmd.tabnext(7)
end, {
    silent = true,
    desc = "Jump to the 7th tabpage",
})
vim.keymap.set("v", "<m-7>", function()
    save_visual_mode()
    vim.cmd.tabnext(7)
end, {
    silent = true,
    desc = "Jump to the 7th tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-8>", function()
    vim.cmd.tabnext(8)
end, {
    silent = true,
    desc = "Jump to the 8th tabpage",
})
vim.keymap.set("v", "<m-8>", function()
    save_visual_mode()
    vim.cmd.tabnext(8)
end, {
    silent = true,
    desc = "Jump to the 8th tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-9>", function()
    vim.cmd.tabnext(9)
end, {
    silent = true,
    desc = "Jump to the 9th tabpage",
})
vim.keymap.set("v", "<m-9>", function()
    save_visual_mode()
    vim.cmd.tabnext(9)
end, {
    silent = true,
    desc = "Jump to the 9th tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-0>", function()
    vim.cmd.tablast()
end, {
    silent = true,
    desc = "Jump to the last tabpage",
})
vim.keymap.set("v", "<m-0>", function()
    save_visual_mode()
    vim.cmd.tablast()
end, {
    silent = true,
    desc = "Jump to the last tabpage",
})

-- }}}

-- arranging tabs {{{

vim.keymap.set({ "n", "i", "v", "t" }, "<m-H>", function()
    tabmux.move_left()
end, {
    silent = true,
    desc = "Move the current tabpage left by one",
})

vim.keymap.set({ "n", "i", "v", "t" }, "<m-L>", function()
    tabmux.move_right()
end, {
    silent = true,
    desc = "Move the current tabpage right by one",
})

-- }}}

-- opening / closing tabs {{{

vim.keymap.set({ "n", "i", "v", "t" }, "<m-w>", function()
    tabmux.close_tab()
end, {
    silent = true,
    desc = "Close the current tabpage",
})

vim.keymap.set({ "n", "i", "t" }, "<m-t>", function()
    vim.cmd.tabnew()
    vim.cmd.terminal()
end, {
    silent = true,
    desc = "Open a new terminal in the cwd",
})
vim.keymap.set("v", "<m-t>", function()
    save_visual_mode()
    vim.cmd.tabnew()
    vim.cmd.terminal()
end, {
    silent = true,
    desc = "Open a new terminal in the cwd",
})

-- }}}
