--- @type fmo.Config|nil
local config = nil

return {
	set = function(new_config)
		config = new_config
	end,
	get = function()
		if config == nil then
			error("fmo: config is not set")
		end
		return config
	end,
}
