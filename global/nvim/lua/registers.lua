if vim.env.PMUX == nil then
	return
end

local augroup = vim.api.nvim_create_augroup("AweRegisters", {})
local tmux = vim.fn.exepath("tmux")

local save_register = function(reg)
	if reg == "+" or reg == "*" then
		return
	end

	local value = vim.fn.getreg(reg)

	local tmux_buffer_name = reg
	if tmux_buffer_name == "" then
		tmux_buffer_name = "vim_unnamed"
	end

	local handle
	handle = vim.loop.spawn(tmux, {
		env = {
			"TMUX=" .. vim.env.PMUX,
			"TMUX_PANE=" .. vim.env.PMUX_PANE,
		},
		args = { "set-buffer", "-b", tmux_buffer_name, value },
	}, function()
		if handle ~= nil then
			handle:close()
		end
	end)
end

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		save_register(string.lower(vim.v.event.regname))
	end,
})

local load_register = function(buffer_name)
	local reg = nil
	if buffer_name == "vim_unnamed" then
		reg = ""
	elseif string.len(buffer_name) == 1 and string.match(buffer_name, "%l") then
		reg = buffer_name
	end

	if reg == nil then
		return
	end

	local value = ""

	local stdout = vim.loop.new_pipe(false)
	local handle
	handle = vim.loop.spawn(
		tmux,
		{
			env = {
				"TMUX=" .. vim.env.PMUX,
				"TMUX_PANE=" .. vim.env.PMUX_PANE,
			},
			stdio = { nil, stdout, nil },
			args = { "save-buffer", "-b", buffer_name, "-" },
		},
		vim.schedule_wrap(function()
			stdout:read_stop()
			stdout:close()
			if handle ~= nil then
				handle:close()
			end

			vim.fn.setreg(reg, value)
		end)
	)

	stdout:read_start(function(err, data)
		if err then
			vim.print("Error listing tmux buffers " .. err)
			return
		end
		if data then
			value = value .. data
		end
	end)
end

local load_all_registers = function()
	local buffer_names = {}

	local stdout = vim.loop.new_pipe(false)
	local handle
	handle = vim.loop.spawn(
		tmux,
		{
			env = {
				"TMUX=" .. vim.env.PMUX,
				"TMUX_PANE=" .. vim.env.PMUX_PANE,
			},
			stdio = { nil, stdout, nil },
			args = { "list-buffers", "-F", "#{buffer_name}" },
		},
		vim.schedule_wrap(function()
			stdout:read_stop()
			stdout:close()
			if handle ~= nil then
				handle:close()
			end

			for _, buffer_name in pairs(buffer_names) do
				load_register(buffer_name)
			end
		end)
	)

	stdout:read_start(function(err, data)
		if err then
			vim.print("Error listing tmux buffers " .. err)
			return
		end
		if data then
			local vals = vim.split(data, "\n")
			for _, d in pairs(vals) do
				if d ~= "" then
					table.insert(buffer_names, d)
				end
			end
		end
	end)
end

vim.api.nvim_create_autocmd("User", {
	group = augroup,
	pattern = "AweFocusIn",
	callback = load_all_registers,
})

return {
	save = save_register,
	load = load_register,
	load_all = load_all_registers,
}
