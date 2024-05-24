-- Only proceed if there is a session file
if vim.env.NVIM_SESSION_FILE == nil then
	return
end

local augroup = vim.api.nvim_create_augroup("AweSessions", {})

vim.g.session_file = vim.env.NVIM_SESSION_FILE
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal"

local saved_vars = {
	tab = {},
	buffer = {},
}

local function serialize(o)
	if type(o) == "number" then
		return o
	elseif type(o) == "nil" then
		return "nil"
	elseif type(o) == "boolean" then
		return o and "true" or "false"
	elseif type(o) == "string" then
		return string.format("%q", o)
	elseif type(o) == "table" then
		local table_str = "{"
		for key, value in pairs(o) do
			table_str = table_str .. "[" .. serialize(key) .. "]=" .. serialize(value) .. ","
		end
		table_str = table_str .. "}"
		return table_str
	else
		error("Cannot serialize a " .. type(o))
	end
end

vim.api.nvim_create_autocmd("VimLeave", {
	group = augroup,
	callback = function()
		vim.cmd.doautocmd("User", "AweSessionWritePre")
		vim.g.AWESAVEDVARS = serialize(saved_vars)
		vim.cmd.wshada()
		vim.cmd("mksession! " .. vim.g.session_file)
	end,
})

local loaded_vars = {
	tab = {},
	buffer = {},
}

vim.cmd.rshada()
if vim.g.AWESAVEDVARS ~= nil then
	loaded_vars = load("return " .. vim.g.AWESAVEDVARS)()
end

local empty_tab = function()
	return {
		vars = {},
		win = {},
	}
end
local init_tab = function(dict, tabpage)
	if dict.tab[tabpage] == nil then
		dict.tab[tabpage] = empty_tab()
	end
	return dict.tab[tabpage]
end

local empty_win = function()
	return {
		vars = {},
	}
end
local init_win = function(dict, window)
	local tabpage = vim.api.nvim_win_get_tabpage(window)
	local winnr = vim.api.nvim_win_get_number(window)
	local tab = init_tab(dict, tabpage)
	if tab.win[winnr] == nil then
		tab.win[winnr] = empty_win()
	end
	return tab.win[winnr]
end

local empty_buf = function()
	return {
		vars = {},
	}
end
local init_buf = function(dict, buffer)
	local buftype = vim.bo[buffer].buftype

	if buftype == "" then
		local bufname = vim.api.nvim_buf_get_name(buffer)
		if dict.buffer[bufname] == nil then
			dict.buffer[bufname] = empty_buf()
		end
		return dict.buffer[bufname]
	elseif buftype == "terminal" then
		local term_window = require("terminal").get_terminal_window(buffer)
		if term_window == nil then
			-- silently fail if the terminal isn't in a window
			return empty_buf()
		end

		local window = init_win(dict, term_window)
		if window.term == nil then
			window.term = empty_buf()
		end
		return window.term
	else
		-- silently fail on other buffer types
		return empty_buf()
	end
end

local get_tab_vars = function(tabpage)
	return init_tab(loaded_vars, tabpage).vars
end

local get_win_vars = function(window)
	return init_win(loaded_vars, window).vars
end

local get_buf_vars = function(buffer)
	return init_buf(loaded_vars, buffer).vars
end

local save_tab_vars = function(tabpage, vars)
	local tab = init_tab(saved_vars, tabpage)
	for key, value in pairs(vars) do
		tab.vars[key] = value
	end
end

local save_win_vars = function(window, vars)
	local win = init_win(saved_vars, window)
	for key, value in pairs(vars) do
		win.vars[key] = value
	end
end

local save_buf_vars = function(buffer, vars)
	local buf = init_buf(saved_vars, buffer)
	for key, value in pairs(vars) do
		buf.vars[key] = value
	end
end

return {
	get_tab_vars = get_tab_vars,
	get_win_vars = get_win_vars,
	get_buf_vars = get_buf_vars,

	save_tab_vars = save_tab_vars,
	save_win_vars = save_win_vars,
	save_buf_vars = save_buf_vars,

	to_save = {
		tab = function(tabpage)
			return init_tab(saved_vars, tabpage)
		end,
		win = function(window)
			return init_win(saved_vars, window)
		end,
		buf = function(buffer)
			return init_buf(saved_vars, buffer)
		end,
	},

	loaded = {
		tab = function(tabpage)
			return init_tab(loaded_vars, tabpage)
		end,
		win = function(window)
			return init_win(loaded_vars, window)
		end,
		buf = function(buffer)
			return init_buf(loaded_vars, buffer)
		end,
	},

	-- for debugging
	loaded_vars = loaded_vars,
	get_saved = function()
		return saved_vars
	end,
}
