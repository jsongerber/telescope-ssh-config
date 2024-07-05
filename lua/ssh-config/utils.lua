local M = {}

---@param patterns string[]
---@param lines string[]
---@return string[]
M.grep_lines = function(patterns, lines)
	local results = {}
	for _, line in ipairs(lines) do
		local lower_line = string.lower(line)
		for _, pattern in ipairs(patterns) do
			local match = string.match(lower_line, pattern)

			if nil ~= match then
				table.insert(results, match)
			end
		end
	end
	return results
end

---@return string[]
M.get_host_list = function(ssh_config_path)
	local host_file = ssh_config_path
	local host_list = {}

	-- read the file
	local file = io.open(vim.fn.expand(host_file), "r")
	if not file then
		error("Could not open file: " .. host_file)
	end

	local content = file:read("*a")
	file:close()
	local lines = vim.split(content, "\n")
	host_list = M.grep_lines({ "%f[%w]host%f[%W]%s*([^*]*)$" }, lines)

	return host_list
end

return M
