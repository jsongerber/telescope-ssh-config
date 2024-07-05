local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

---@enum Client
local CLIENT = {
	OIL = "oil",
	NETRW = "netrw",
}

---@class Config
---@field client Client
local M = {}

M.config = {
	client = "oil",
}

---@param config Config
M.init_config = function(config)
	config = config or {}

	if config.client ~= nil then
		assert(
			config.client == CLIENT.OIL or config.client == CLIENT.NETRW,
			"config.client must be either 'oil' or 'netrw'"
		)
	end

	M.config = vim.tbl_extend("force", M.config, config)
end

---@param user string
---@param hostname string
---@param port string
---@return string
M.get_cmd = function(user, hostname, port)
	if M.config.client == nil then
		error("client is not set. Please call setup() first")
	end

	local url = ""
	if user ~= nil then
		url = user .. "@"
	end

	url = url .. hostname

	if port ~= nil then
		url = url .. ":" .. port
	end

	if "oil" == M.config.client then
		return "Oil oil-ssh://" .. url .. "/"
	end

	if "netrw" == M.config.client then
		return "e scp://" .. url .. "/"
	end

	error("client is not supported: " .. M.config.client)
end

---@param opts table
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
						{ "^user%f[%W]%s*(.*)", "^hostname%f[%W]%s*(.*)", "^port%f[%W]%s*(.*)" },
						ssh_host_infos
					)
					if #user ~= 3 then
						vim.notify("Not enough data found for " .. selection[1], vim.log.levels.WARN)
						return true
					end

					local cmd = M.get_cmd(user[1], user[2], user[3])
					vim.cmd(cmd)
				end)
				return true
			end,
		})
		:find()
end

-- to execute the function
return M
