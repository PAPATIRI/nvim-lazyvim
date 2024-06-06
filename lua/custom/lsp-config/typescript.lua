local mason_registry = require("mason-registry")
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
  .. "/node_modules/@vue/language-server"

local lspconfig = require("lspconfig")

lspconfig.tsserver.setup({
  -- filetypes = { "typescript", "typescriptreact", "typescript.tsx", "vue" },
  -- cmd = { "typescript-language-server", "--stdio" },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
      },
    },
  },
})

lspconfig.volar.setup({
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
})
