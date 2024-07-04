local telescope = require("telescope")
local ssh_config = require("ssh-config")

return telescope.register_extension({
	setup = function(config, _)
		ssh_config.init_config(config)
	end,
	exports = {
		["ssh-config"] = function(opts)
			ssh_config.ssh_config(opts)
		end,
	},
})
