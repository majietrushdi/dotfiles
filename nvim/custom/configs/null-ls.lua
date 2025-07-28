local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local opts = {
  sources = {
    null_ls.builtins.formatting.gofumpt.with { filetypes = { "go" }},
    null_ls.builtins.formatting.goimports_reviser.with { filetypes = { "go" }},
    null_ls.builtins.formatting.golines.with { filetypes = { "go" }},
    null_ls.builtins.formatting.phpcbf.with {
      filetypes = { "php" },
      command = "vendor/bin/phpcbf",
      args = { "-q", "--stdin-path=$FILENAME", "-" },
      condition = function (utils)
        return utils.root_has_file "vendor/bin/phpcbf"
      end,
    },
    null_ls.builtins.formatting.phpcsfixer.with {
      filetypes = { "php" },
      command = "vendor/bin/php-cs-fixer",
      args = { "--no-interaction", "--quiet", "fix", "$FILENAME" },
      condition = function (utils)
        return utils.root_has_file "vendor/bin/php-cs-fixer"
      end,
    },
    -- phpstan inline diagnostics seems to create incorrect character spacing in the open buffer
    -- until that is resolved, leave this shit alone as it is annoying
    null_ls.builtins.diagnostics.phpstan.with {
      filetypes = { "php" },
      command = "vendor/bin/phpstan",
      extra_args = { "--memory-limit=-1" },
      -- args = { "analyze", "--error-format", "json", "--no-progress", "$FILENAME" },
      condition = function (utils)
        return utils.root_has_file "phpstan.neon"
      end,
    },
    null_ls.builtins.diagnostics.mypy.with {
      filetypes = { "python" },
    },
    -- null_ls.builtins.diagnostics.ruff.with {
    --   filetypes = { "python" },
    -- },
    -- null_ls.builtins.formatting.ruff.with {
    --   filetypes = { "python" },
    -- },
    null_ls.builtins.formatting.prettierd.with { filetypes = { "html", "css", "php" }},
  },
  on_attach = function (client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function ()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}
return opts
