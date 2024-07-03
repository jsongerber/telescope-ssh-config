local telescope = require("telescope")
local ssh_config = require("ssh-config")

return telescope.register_extension({
	setup = function(ext_config, config)
		vim.print(vim.inspect("--------config"))
		vim.print(vim.inspect(ext_config))
		ssh_config.init_config(config)
	end,
	exports = {
		["ssh-config"] = function(opts)
			ssh_config.ssh_config(opts)
		end,
	},
})
