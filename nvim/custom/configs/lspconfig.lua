local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

local get_intelephense_license = function ()
  local f = assert(io.open(os.getenv("HOME") .. "/intelephense/license.txt", "rb"))
  local content = f:read("*a")
  f:close()

  return string.gsub(content, "%s+", "")
end

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("gowork", "gomod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      }
    },
  },
}

lspconfig.pyright.setup ({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
})

lspconfig.intelephense.setup ({
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = { licenseKey = get_intelephense_license() },
  filetypes = { "php" },
})

lspconfig.html.setup ({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html" },
})

lspconfig.cssls.setup ({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "css" },
})

lspconfig.tailwindcss.setup({})

lspconfig.ruff.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python" },
})

