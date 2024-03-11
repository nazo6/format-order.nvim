local path_sep = vim.uv.os_uname().sysname == "Windows" and "\\" or "/"

---@param files string[]
local root_pattern = function(files)
  return function(path)
    local dirname = vim.fs.dirname(path)
    local found = nil
    for _, file in ipairs(files) do
      local f = vim.fs.find(file, { upward = true, path = dirname })[1]
      if f then
        found = f
        break
      end
    end

    if found then
      local root = vim.fn.fnamemodify(found, ":p:h")
      local _, node_count = string.gsub(root, path_sep, "")
      return { enabled = true, priority = node_count }
    else
      return { enabled = false }
    end
  end
end

return {
  ---@param generate_opts fmo.FormatterSpecifier
  ---@return fmo.InitCondition
  get_init_condition = function(generate_opts)
    return function()
      if generate_opts.init_condition ~= nil then
        if not generate_opts.init_condition() then
          return false
        end
      end

      return true
    end
  end,

  ---@param generate_opts fmo.FormatterSpecifier
  ---@return fmo.BufCondition
  get_buf_condition = function(generate_opts)
    return function(bufnr)
      local priority = 0

      if generate_opts.root_pattern ~= nil then
        local path = vim.api.nvim_buf_get_name(bufnr)
        local root_search_res = root_pattern(generate_opts.root_pattern or {})(path)
        if not root_search_res.enabled then
          return root_search_res
        end

        priority = root_search_res.priority
      end

      if generate_opts.filetypes ~= nil then
        local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
        if not (vim.tbl_contains(generate_opts.filetypes, ft)) then
          return { enabled = false }
        end
      end

      if generate_opts.buf_condition ~= nil then
        local buf_condition_res = generate_opts.buf_condition(bufnr)
        if not buf_condition_res.enabled then
          return buf_condition_res
        end
      end

      return { enabled = true, priority = priority }
    end
  end,
}
