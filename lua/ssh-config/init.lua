local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.config = {
	cmd = "ssh",
}

M.init_config = function(config)
	config = config or {}

	M.config = vim.tbl_extend("force", M.config, config)
end

M.ssh_config = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Select a host",
			finder = finders.new_table({ results = require("ssh-config.utils").get_host_list() }),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local ssh_host_infos = vim.fn.systemlist("ssh -GT " .. selection[1])

					if vim.v.shell_error ~= 0 then
						vim.notify("Error: " .. vim.inspect(ssh_host_infos), vim.log.levels.WARN)
						return true
					end

					local user = require("ssh-config.utils").grep_lines(
						{ "^user%f[%W]%s*(.*)", "^hostname%f[%W]%s*(.*)" },
						ssh_host_infos
					)
					if #user ~= 2 then
						vim.notify("Not enough data found for " .. selection[1], vim.log.levels.WARN)
						return true
					end

					local config = require("telescope._extensions.ssh-config").config
					vim.print(vim.inspect("---???????????"))
					vim.print(M.config.cmd)
					-- Execute :Oil oil-ssh://ssh <user>@<host>
					vim.cmd("Oil oil-ssh://" .. user[1] .. "@" .. user[2] .. "/")
				end)
				return true
			end,
		})
		:find()
end

-- to execute the function
return M
