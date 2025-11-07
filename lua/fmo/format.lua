local c = require("fmo.config")
local cond = require("fmo.state.condition")
local u = require("fmo.utils")

local M = {}

---Get formatters for specified buffer
---nil if no formatters are configured for the filetype
---@param bufnr number
---@return fmo.FormatterDef[]|nil
M.get_formatters = function(bufnr)
	local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

	local ft_config = c.get().filetypes[ft]
	if ft_config == nil then
		return nil
	end

	---@type fmo.FormatterDef[]
	local enabled_formatters = {}

	for _, fmt_group in ipairs(ft_config) do
		if fmt_group.buf_condition ~= nil then
			if not fmt_group.buf_condition(bufnr, enabled_formatters) then
				goto continue2
			end
		end

		for _, select_first_group in ipairs(fmt_group) do
			local highest_priority = -1
			local highest_priority_fm_spec = nil

			if not (vim.islist(select_first_group)) then
				select_first_group = { select_first_group }
			end
			for _, fmtr_def in ipairs(select_first_group) do
				local fmtr = u.get_formatter(fmtr_def)
				if fmtr == nil then
					vim.notify("Formatter not found: " .. fmtr_def.name, vim.log.levels.WARN)
					goto continue
				end

				local init_condition = cond.get_init_condition(u.formatter_id(fmtr_def), fmtr.init_condition)
				if not init_condition then
					goto continue
				end

				local buf_condition = fmtr.buf_condition(bufnr)
				if not buf_condition.enabled then
					goto continue
				end

				if buf_condition.priority > highest_priority then
					highest_priority = buf_condition.priority
					highest_priority_fm_spec = fmtr_def
				end

				::continue::
			end

			if highest_priority_fm_spec ~= nil then
				table.insert(enabled_formatters, highest_priority_fm_spec)
				break
			end
		end

		::continue2::
	end

	if #enabled_formatters == 0 and ft_config.default ~= nil then
		if vim.islist(ft_config.default) then
			enabled_formatters = ft_config.default
		else
			enabled_formatters = { ft_config.default }
		end
	end

	return enabled_formatters
end

--- Format current buffer
--- @param format_options_arg fmo.FormatOpts|nil
--- @return fmo.FormatterDef[]|nil
M.format = function(format_options_arg)
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

	local buf = vim.api.nvim_get_current_buf()
	for _, fm_specifier in ipairs(formatter_specs) do
		local fmtr = u.get_formatter(fm_specifier)
		if fmtr == nil then
			error("Formatter not found: " .. fm_specifier)
		end

		fmtr.format(buf, format_options)
	end

	return formatter_specs
end

return M
