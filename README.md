# format-order.nvim

Configure formatters in a consistent way!

## About

This plugin unifies [conform.nvim](https://github.com/stevearc/conform.nvim) and
nvim-lsp, so that you can configure formatters in a consistent way.

## Install & Setup

Config example for `lazy.nvim`:

```lua
{
  "nazo6/format-order.nvim",
  event = { "BufRead" },
  dependencies = {
    {
      "stevearc/conform.nvim",
      dependencies = { "williamboman/mason.nvim" },
      config = function()
        require("conform").setup()
      end,
 },
  },
  config = function()
    local specs = {
      prettierd = {
        type = "conform",
        name = "prettierd",
        root_pattern = {
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.json5",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.mjs",
          ".prettierrc.toml",
          "prettier.config.js",
          "prettier.config.cjs",
        },
      },
      deno_fmt = { type = "conform", name = "deno_fmt", root_pattern = { "deno.json", "deno.jsonc" } },
    }

    ---@type table<string, fmo.FormatterSpecifierGroup>
    local formatter_groups = {
      web = {
        { -- In this level, one which was enabled for the first time will be selected
          { { type = "lsp", name = "denols" } },
          { { type = "lsp", name = "biome" } },
          {
            specs.prettierd,
            specs.deno_fmt,
          },
          { { type = "lsp", name = "vtsls" } },
        },
      },
      lua = {
        {
          {
            { type = "conform", name = "stylua", root_pattern = { "stylua.toml" } },
            { type = "lsp", name = "lua_ls" },
          },
        },
      },
    }

    --- @type table<string, fmo.FileTypeConfig>
    local filetypes = {
      html = { group = formatter_groups.web, default = specs.prettierd },
      css = { group = formatter_groups.web, default = specs.prettierd },
      javascript = { group = formatter_groups.web, default = specs.deno_fmt },
      typescript = { group = formatter_groups.web, default = specs.deno_fmt },
      javascriptreact = { group = formatter_groups.web, default = specs.deno_fmt },
      typescriptreact = { group = formatter_groups.web, default = specs.deno_fmt },
      json = { group = formatter_groups.web, default = specs.deno_fmt },
      jsonc = { group = formatter_groups.web, default = specs.deno_fmt },
      markdown = { group = formatter_groups.web, default = specs.deno_fmt },
      lua = { group = formatter_groups.lua },
    }

    require("fmo").setup {
      filetypes = filetypes,
      fallback_lsp = {
        no_ft = true,
        no_formatter = false
      }
    }

    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      callback = function()
        local _ = require("fmo").format()
      end,
    })
  end,
},
```
