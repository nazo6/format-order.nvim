local M = {}

---Get the formatter id from a specifier
---@param def fmo.FormatterDef
M.formatter_id = function(def)
	return def.type .. def.name
end

local formatter_cache = {}

---Get a formatter from a definition
---@param definition fmo.FormatterDef
---@return fmo.Formatter|nil
M.get_formatter = function(definition)
	local formatter_id = M.formatter_id(definition)
	if formatter_cache[formatter_id] then
		return formatter_cache[formatter_id]
	end

	---@type boolean, fmo.Integration
	local ok, integ = pcall(require, "fmo.integration." .. definition.type)
	if not ok then
		return nil
	end

	local formatter = integ.formatter_generator(definition)
	return formatter
end

return M
