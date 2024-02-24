local c = require("fmo.config")
local cond = require("fmo.state.condition")
local u = require("fmo.utils")

local M = {}

---Get formatters for specified buffer
---nil if no formatters are configured for the filetype
---@param bufnr number
---@return fmo.FormatterSpecifier[]|nil
M.get_formatters = function(bufnr)
	local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

	local ft_fmt_group = c.get().filetypes[ft]
	if ft_fmt_group == nil then
		return nil
	end

	local enabled_formatter_specs = {}

	for _, exclusive_fm_group in ipairs(ft_fmt_group) do
		for _, select_first_group in ipairs(exclusive_fm_group) do
			local highest_priority = -1
			local highest_priority_fm_spec = nil

			for _, fm_specifier in ipairs(select_first_group) do
				local fmtr = u.get_formatter(fm_specifier)
				if fmtr == nil then
					vim.notify("Formatter not found: " .. fm_specifier, vim.log.levels.WARN)
					goto continue
				end

				local init_condition = cond.get_init_condition(u.formatter_id(fm_specifier), fmtr.init_condition)
				if not init_condition then
					goto continue
				end

				local buf_condition = fmtr.buf_condition(bufnr)
				if not buf_condition.enabled then
					goto continue
				end

				if buf_condition.priority > highest_priority then
					highest_priority = buf_condition.priority
					highest_priority_fm_spec = fm_specifier
				end

				::continue::
			end

			if highest_priority_fm_spec ~= nil then
				table.insert(enabled_formatter_specs, highest_priority_fm_spec)
				break
			end
		end
	end

	return enabled_formatter_specs
end

--- Format current buffer
--- @param format_options_arg fmo.FormatOpts|nil
--- @param cb function|nil
--- @return fmo.FormatterSpecifier[]|nil
M.format = function(format_options_arg, cb)
	local format_options = format_options_arg or {}

	local formatter_specs = M.get_formatters(0)

	if formatter_specs == nil or #formatter_specs == 0 then
		local fallback
		local fallback_lsp = c.get().fallback_lsp or {}
		if formatter_specs == nil then
			fallback = fallback_lsp.no_ft or true
		else
			fallback = fallback_lsp.no_formatter or false
		end

		if fallback then
			vim.lsp.buf.format({
				async = format_options.async,
			})
		end

		return formatter_specs
	end

	for _, fm_specifier in ipairs(formatter_specs) do
		local fmtr = u.get_formatter(fm_specifier)
		if fmtr == nil then
			error("Formatter not found: " .. fm_specifier)
		end
		fmtr.format(0, format_options, cb or function() end)
	end

	return formatter_specs
end

return M
