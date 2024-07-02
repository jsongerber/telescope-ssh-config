local M = {}

---@param pattern string
---@param lines string[]
M.grep_lines = function(pattern, lines)
	local results = {}
	for _, line in ipairs(lines) do
		local lower_line = string.lower(line)
		if string.match(lower_line, pattern) then
			table.insert(results, line)
		end
	end
	return results
end

return M
