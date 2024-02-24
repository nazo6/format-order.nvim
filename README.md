# format-order.nvim

Configure formatters in a consistent way!

## About

This plugin unify [conform.nvim](https://github.com/stevearc/conform.nvim) and
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig), so that you can
configure formatters in a consistent way.

## Install & Setup

In `lazy.nvim`:

```lua
{
  "formatter-order.nvim",
  lazy = false,
  dir = "~/dev/neovim/format-order.nvim",
  config = function()
    ---@type table<string, FmoConfigFormatterGroup>
    local formatter_groups = {
      web = {
        { -- In this level, one which was enabled for the first time will be selected
          { type = "lsp", name = "deno" },
          { type = "lsp", name = "biome" },
          { -- In this level, all condition function will be executed but one which got highest priority will be selected.
            {
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
            { type = "conform", name = "deno_fmt", root_pattern = { "deno.json", "deno.jsonc" } },
          },
        {
          -- For the "lsp" type, the root_pattern option cannot be specified because the plugin only activates the formatter when lsp is attached
          type = "lsp", name = "vtsls" },
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

    local filetypes = {
      html = formatter_groups.web,
      css = formatter_groups.web,
      scss = formatter_groups.web,
      javascript = formatter_groups.web,
      typescript = formatter_groups.web,
      javascriptreact = formatter_groups.web,
      typescriptreact = formatter_groups.web,
      -- If you set the file type correctly in the formatter options, you can include a formatter that does not support that file type.
      json = formatter_groups.web,
      lua = formatter_groups.lua,
    }

    require("fmo").setup {
      filetypes = filetypes,
      fallback_lsp = true,
    }
  end,
},
```
