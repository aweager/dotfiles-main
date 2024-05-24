-- vim:foldmethod=marker

if vim.env.USE_NTM ~= nil then
	vim.o.showtabline = 2
end

local save_visual_mode = function()
	require("localmode").save_mode("v")
end

-- pin tab {{{

vim.keymap.set("n", "<leader>p", function()
	if vim.t.tab_pinned ~= nil then
		vim.t.mux_tab_pinned = nil
	else
		vim.t.mux_tab_pinned = 1
	end
	vim.cmd.redrawtabline()
end, {
	silent = true,
	desc = "Pin the current tabpage",
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
	vim.cmd.tabmove("-1")
	vim.cmd.redrawtabline()
end, {
	silent = true,
	desc = "Move the current tabpage left by one",
})

vim.keymap.set({ "n", "i", "v", "t" }, "<m-L>", function()
	vim.cmd.tabmove("+1")
	vim.cmd.redrawtabline()
end, {
	silent = true,
	desc = "Move the current tabpage right by one",
})

-- }}}

-- opening / closing tabs {{{

vim.keymap.set({ "n", "i", "v", "t" }, "<m-w>", function()
	if #vim.api.nvim_list_tabpages() == 1 then
		vim.cmd.quitall()
	else
		vim.cmd.tabclose()
	end
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

-- configure mux vars {{{

local set_vars = function(args)
	local bufnr = args.bufnr
	local dict = vim.b[bufnr].mux or {}
	for name, val in pairs(args.vars) do
		if val == "" then
			dict[name] = nil
		else
			dict[name] = val
		end
	end
	vim.b[bufnr].mux = dict
	vim.cmd.redrawtabline()
end

local lcd = function(args)
	local buf = args.buf
	local dir = args.dir
	vim.api.nvim_buf_call(buf, function()
		vim.cmd.lcd(dir)
	end)
end

local pid_to_bufnr = function(pid)
	for _, buf in pairs(vim.api.nvim_list_bufs()) do
		if vim.b[buf].terminal_job_pid == pid then
			return buf
		end
	end
	return -1
end

local augroup = vim.api.nvim_create_augroup("AweMux", {})
vim.api.nvim_create_autocmd("BufNew", {
	group = augroup,
	callback = function(ev)
		vim.b[ev.buf].mux = {}
		vim.cmd.redrawtabline()
	end,
})

if vim.env.USE_NTM == nil then
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = augroup,
		callback = function()
			-- TODO: use same functions as tabbar
			local title = vim.fn.expand("%:t")
			local icon = ""
			local rename_window = vim.g.awe_config .. "/global/zsh/fbin/rename_window"
			print(title .. " " .. icon)
			handle = vim.loop.spawn("zsh", {
				args = { rename_window, title, icon },
			}, function()
				handle:close()
			end)
		end,
	})
end

-- }}}

-- get mux vars {{{

local get_default_icon_color = function(buf)
	if vim.bo[buf].buftype == "terminal" then
		return "", nil
	end

	local devicons = require("nvim-web-devicons")
	local icon, color = devicons.get_icon_color_by_filetype(vim.bo[buf].filetype, { default = false })
	if icon ~= nil then
		return icon, color
	end

	return devicons.get_default_icon(), nil
end

local get_default_title = function(buf)
	if vim.bo[buf].buftype == "terminal" then
		return vim.b[buf].term_title
	end

	local bufname = vim.api.nvim_buf_get_name(buf)
	local basename = vim.fn.fnamemodify(bufname, ":t")
	return basename or "[No Name]"
end

local get_default_title_style = function(buf)
	if vim.bo[buf].buftype == "terminal" then
		return "default"
	elseif vim.bo[buf].modified then
		return "italic"
	else
		return "default"
	end
end

local get_vars = function(buf)
	buf = buf or vim.api.nvim_get_current_buf()

	local mux_vars = vim.b[buf].mux or {}
	local icon, icon_color = get_default_icon_color(buf)
	return {
		icon = mux_vars.icon or icon,
		icon_color = mux_vars.icon_color or icon_color,
		title = mux_vars.title or get_default_title(buf),
		title_style = mux_vars.title_style or get_default_title_style(buf),
	}
end

-- }}}

return {
	set_vars = set_vars,
	get_vars = get_vars,
	lcd = lcd,
	pid_to_bufnr = pid_to_bufnr,
}
