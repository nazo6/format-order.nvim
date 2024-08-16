local i_utils = require("fmo.integration.utils")

---@type fmo.Integration
return {
	formatter_generator = function(generate_opts)
		local conform_formatter = require("conform").formatters[generate_opts.name]
		if not conform_formatter == nil then
			vim.notify("Conform formatter not found: " .. generate_opts.name, vim.log.levels.ERROR)
			return nil
		end

		--- @type fmo.Formatter
		return {
			init_condition = i_utils.get_init_condition(generate_opts),
			buf_condition = i_utils.get_buf_condition(generate_opts),
			format = function(buf, opts)
				require("conform").format({
					bufnr = buf,
					formatters = { generate_opts.name },
					async = opts.async,
					timeout = opts.timeout_ms,
				})
			end,
		}
	end,
}
