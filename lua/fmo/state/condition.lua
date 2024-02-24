---@type table<string, boolean>
local init_condition_state = {}

local M = {
	---@param formatter_id string
	---@param intiializer fun(): boolean
	---@return boolean
	get_init_condition = function(formatter_id, intiializer)
		if init_condition_state[formatter_id] == nil then
			init_condition_state[formatter_id] = intiializer()
		end
		return init_condition_state[formatter_id]
	end,
}

return M
