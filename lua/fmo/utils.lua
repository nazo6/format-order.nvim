local M = {}

---Get the formatter id from a specifier
---@param specifier fmo.FormatterSpecifier
M.formatter_id = function(specifier)
	return specifier.type .. specifier.name
end

local formatter_cache = {}

---Get a formatter from a specifier
---@param specifier fmo.FormatterSpecifier
---@return fmo.Formatter|nil
M.get_formatter = function(specifier)
	local formatter_id = M.formatter_id(specifier)
	if formatter_cache[formatter_id] then
		return formatter_cache[formatter_id]
	end

	---@type boolean, fmo.Integration
	local ok, integ = pcall(require, "fmo.integration." .. specifier.type)
	if not ok then
		return nil
	end

	local formatter = integ.formatter_generator(specifier)
	return formatter
end

return M
