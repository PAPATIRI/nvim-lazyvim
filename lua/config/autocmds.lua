-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- local lsp_conficts, _ = pcall(vim.api.nvim_get_autocmds, { group = "LspAttach_conflicts" })
-- if not lsp_conficts then
--   vim.api.nvim_create_augroup("LspAttach_conflicts", {})
-- end
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspAttach_conflicts",
--   desc = "prevent tsserver and volar competing",
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end
--     -- local active_clients = vim.lsp.get_active_clients()
--     local active_clients = vim.lsp.get_clients()
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     -- prevent tsserver and volar competing
--     -- if client.name == "volar" or require("lspconfig").util.root_pattern("nuxt.config.ts")(vim.fn.getcwd()) then
--     -- OR
--     if client and client.name == "volar" then
--       for _, client_ in pairs(active_clients) do
--         -- stop tsserver if volar is already active
--         if client_.name == "tsserver" then
--           client_.stop()
--         end
--       end
--     elseif client and client.name == "tsserver" then
--       for _, client_ in pairs(active_clients) do
--         -- prevent tsserver from starting if volar is already active
--         if client_.name == "volar" then
--           client.stop()
--         end
--       end
--     end
--   end,
-- })
--
-- -- Enable auto import module and completion of module name for Vue files using Volar
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "vue",
--   callback = function()
--     vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
--   end,
-- })
-- Define an autocmd group for the blade workaround
local augroup = vim.api.nvim_create_augroup("lsp_blade_workaround", { clear = true })

-- Autocommand to temporarily change 'blade' filetype to 'php' when opening for LSP server activation
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = "*.blade.php",
  callback = function()
    vim.bo.filetype = "php"
  end,
})

-- Additional autocommand to switch back to 'blade' after LSP has attached
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.blade.php",
  callback = function(args)
    vim.schedule(function()
      -- Check if the attached client is 'intelephense'
      local clients = vim.lsp.buf_get_clients(args.buf)
      for _, client in ipairs(clients) do
        if client.name == "intelephense" and client.attached_buffers[args.buf] then
          -- vim.api.nvim_buf_set_option(args.buf, "filetype", "blade")
          -- -- update treesitter parser to blade
          -- vim.api.nvim_buf_set_option(args.buf, "syntax", "blade")
          vim.bo[args.buf].filetype = "blade"
          vim.bo[args.buf].syntax = "blade"
          break
        end
      end
    end)
  end,
})

-- make $ part of the keyword for php.
vim.api.nvim_exec(
  [[
autocmd FileType php set iskeyword+=$
]],
  false
)
