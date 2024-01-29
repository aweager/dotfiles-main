local theme = {
	head = "TabLineHead",
	fill = "TabLineFill",

	current_tab = {
		default = "TabLineSel",
		modified = "TabLineSelItalic",
		italic = "TabLineSelItalic",
	},

	tab = {
		default = "TabLine",
		modified = "TabLineItalic",
		italic = "TabLineItalic",
	},

	win = "TabLine",
	tail = "TabLine",
}

local function get_icon_and_hl(tab, devicons)
	local buffer = tab.current_win().buf()

	local hl_table = nil
	if tab.is_current() then
		hl_table = theme.current_tab
	else
		hl_table = theme.tab
	end

	local buffer_overrides = vim.b[buffer.id].mux or {}
	if buffer_overrides.icon ~= nil and buffer_overrides.icon ~= "" then
		return buffer_overrides.icon, hl_table.default
	end

	local buffer_info = vim.api.nvim_buf_call(buffer.id, function()
		return {
			filename = vim.fn.expand("%:t"),
			extension = vim.fn.expand("%:e"),
		}
	end)

	local icon = nil
	local icon_hl = nil
	if vim.bo[buffer.id].bt == "terminal" then
		icon, icon_hl = devicons.get_icon_by_filetype("zsh", { default = true })
		icon = "λ"
	else
		icon, icon_hl = devicons.get_icon(buffer_info.filename, buffer_info.extension, { default = true })
	end

	if not tab.is_current() then
		icon_hl = theme.tab.default
	end
	return icon, icon_hl
end

local function get_tab_name(tabid)
	local window = vim.api.nvim_tabpage_get_win(tabid)
	local buffer = vim.api.nvim_win_get_buf(window)

	if vim.t[tabid].tab_pinned ~= nil then
		return ""
	end

	return vim.api.nvim_buf_call(buffer, function()
		local mux = vim.b.mux or {}
		if mux.title ~= nil then
			return mux.title
		end

		if vim.bo.buftype == "terminal" then
			return vim.b.term_title
		end

		local basename = vim.fn.expand("%:t")
		if basename ~= "" then
			return basename
		end
		return "[No Name]"
	end)
end

local function get_tab_hl(tab)
	local buffer = tab.current_win().buf()

	local hl_table = nil
	if tab.is_current() then
		hl_table = theme.current_tab
	else
		hl_table = theme.tab
	end

	local mux = vim.b[buffer.id].mux or {}
	local title_style = mux.title_style
	if title_style == nil or title_style == "" then
		if vim.bo[buffer.id].modified then
			title_style = "modified"
		else
			title_style = "default"
		end
	end
	return hl_table[title_style]
end

local head = {
	{
		"  [" .. vim.fn.fnamemodify(vim.g.root_dir, ":t") .. "] ",
		hl = theme.head,
		margin = " ",
	},
}

local tabbar = { "nanozuki/tabby.nvim" }
tabbar.dependencies = { "nvim-tree/nvim-web-devicons" }
tabbar.config = function()
	local tab_bar_color_cterm = "darkcyan"
	local tab_bar_color_gui = "cyan"
	vim.api.nvim_set_hl(0, "TabLineHead", {
		fg = "black",
		bg = tab_bar_color_gui,
		ctermfg = "black",
		ctermbg = tab_bar_color_cterm,
	})
	vim.api.nvim_set_hl(0, "TabLineFill", {
		fg = tab_bar_color_gui,
		bg = tab_bar_color_gui,
		ctermfg = tab_bar_color_cterm,
		ctermbg = tab_bar_color_cterm,
	})
	vim.api.nvim_set_hl(0, "TabLineSel", {
		fg = "white",
		bold = true,
		ctermfg = "white",
		cterm = {
			bold = true,
		},
	})
	vim.api.nvim_set_hl(0, "TabLineSelItalic", {
		fg = "white",
		bold = true,
		italic = true,
		ctermfg = "white",
		cterm = {
			bold = true,
			italic = true,
		},
	})

	vim.api.nvim_set_hl(0, "TabLine", {
		fg = "lightgray",
		bg = "gray",
		ctermfg = "lightgray",
		ctermbg = "darkgray",
	})
	vim.api.nvim_set_hl(0, "TabLineItalic", {
		fg = "lightgray",
		bg = "gray",
		italic = true,
		ctermfg = "lightgray",
		ctermbg = "darkgray",
		cterm = {
			italic = true,
		},
	})

	local devicons = require("nvim-web-devicons")
	require("tabby.tabline").set(function(line)
		return {
			head,
			line.tabs().foreach(function(tab)
				local hl = get_tab_hl(tab)
				local icon, icon_hl = get_icon_and_hl(tab, devicons)

				return {
					line.sep("", hl, theme.fill),
					{
						icon,
						hl = icon_hl,
					},
					tab.name(),
					line.sep("", hl, theme.fill),
					hl = hl,
					margin = " ",
				}
			end),
			line.spacer(),
			hl = theme.fill,
		}
	end, {
		tab_name = {
			name_fallback = get_tab_name,
		},
		buf_name = {
			mode = "tail",
		},
	})
end

return { tabbar }
