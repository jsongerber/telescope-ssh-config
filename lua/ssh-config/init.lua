local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.setup = function() end

---@return string[]
local get_host_list = function()
	local host_file = "~/.ssh/config"
	local host_list = {}

	-- read the file
	local file = io.open(vim.fn.expand(host_file), "r")
	if file then
		local content = file:read("*a")
		local lines = vim.split(content, "\n")
		local host_list = require("ssh-config.utils").grep_lines("%f[%w]host%f[%W]", lines)
		for host in host_list do
			if host == "*" then
				table.remove(host_list, host)
			end
		end
		file:close()
	end

	return host_list
end

M.ssh_config = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Select a host",
			finder = finders.new_table({ results = get_host_list() }),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local ssh_host_infos = vim.fn.system("ssh -G " .. selection[1])

					if vim.v.shell_error ~= 0 then
						vim.notify("Error: " .. vim.inspect(ssh_host_infos), "error")
						return true
					end

					local ssh_host_infos_matches =
						require("ssh-config.utils").grep_lines("%f[%w]host%f[%W]", ssh_host_infos)

					-- print(vim.inspect(selection))
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

-- to execute the function
return M
