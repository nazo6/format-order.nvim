local i_utils = require("fmo.integration.utils")

---@type fmo.Integration
return {
	formatter_generator = function(generate_opts)
		--- @type fmo.Formatter
		return {
			init_condition = i_utils.get_init_condition(generate_opts),
			buf_condition = function(bufnr)
				local lsp_available = vim.lsp.get_clients({ bufnr = bufnr, name = generate_opts.name })[1] ~= nil
				if not lsp_available then
					return { enabled = false }
				end

				return i_utils.get_buf_condition(generate_opts)(bufnr)
			end,
			format = function(buf, opts)
				vim.lsp.buf.format({
					name = generate_opts.name,
					async = opts.async,
					bufnr = buf,
					timeout = opts.timeout_ms,
				})
			end,
		}
	end,
}
