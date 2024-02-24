---@type fmo.Integration
return {
	formatter_generator = function(generator_opts)
		--- @type fmo.Formatter
		return {
			init_condition = function()
				return true
			end,
			buf_condition = function(bufnr)
				return {
					enabled = vim.lsp.get_clients({ bufnr = bufnr, name = generator_opts.name })[1] ~= nil,
					priority = 0,
				}
			end,
			format = function(buf, opts, cb)
				vim.lsp.buf.format({
					name = generator_opts.name,
					async = opts.async,
					bufnr = buf,
				})
			end,
		}
	end,
}
