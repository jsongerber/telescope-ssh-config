return require("telescope").register_extension({
	setup = function(ext_config, config)
		-- access extension config and user config
	end,
	exports = {
		["ssh-config"] = function(opts)
			require("ssh-config").ssh_config(opts)
		end,
	},
})