local c = require("fmo.config")

local M = {}

--- Set config
---@param config fmo.Config
M.setup = function(config)
	c.set(config)
end

M.format = require("fmo.format").format
M.get_formatters = require("fmo.format").get_formatters

return M
