return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local has_dap_config, dap_config = pcall(require, "dap_config")
			if has_dap_config then
				dap.adapters = dap_config.adapters
				dap.configurations = dap_config.configurations
			end
		end,
	},
	"rcarriga/nvim-dap-ui",
}
