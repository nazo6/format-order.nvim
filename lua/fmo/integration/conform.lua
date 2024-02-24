local root_pattern = function(pattern)
  local search = require("lspconfig").util.root_pattern(unpack(pattern))
  return function(path)
    local root = search(path)
    if root ~= nil then
      local _, node_count = string.gsub(root, "/", "")
      return { enabled = true, priority = node_count }
    else
      return { enabled = false }
    end
  end
end

---@type fmo.Integration
return {
  formatter_generator = function(generate_opts)
    --- @type fmo.Formatter
    return {
      init_condition = function()
        return true
      end,
      buf_condition = function(bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        return root_pattern(generate_opts.root_pattern or {})(path)
      end,
      format = function(buf, opts, cb)
        require("conform").format({
          bufnr = buf,
          formatters = { generate_opts.name },
          async = opts.async,
        }, function()
          cb()
        end)
      end,
    }
  end,
}
