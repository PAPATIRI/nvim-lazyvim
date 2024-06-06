-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.wrap = true
opt.linebreak = true
opt.clipboard = "unnamedplus"

-- vim.api.nvim_create_user_command("LazyVimNew", function()
--   local output = vim.fn.system({
--     "curl",
--     "-s",
--     "https://api.github.com/repos/LazyVim/LazyVim/releases/latest",
--   })
--   local release = vim.json.decode(output)
--   local body = release.body:gsub("\n", "\n  ")
--   vim.api.nvim_echo({ { "What's new in LazyVim:", "Title" }, { body } }, false, {})
-- end, {})
--
vim.api.nvim_create_user_command("LazyVimNew", function()
  local output = vim.fn.system({
    "curl",
    "-s",
    "https://api.github.com/repos/LazyVim/LazyVim/releases/latest",
  })
  local release = vim.json.decode(output)
  local body = release.body
  body = body:gsub("\\([n])", { n = "\n" }) -- add indentation to each line

  -- Create a new buffer
  local buf_handle = vim.api.nvim_create_buf(false, true)

  -- Create a new float window
  local width = 80
  local height = 10
  local col = math.floor((vim.api.nvim_win_get_width(0) - width) / 2)
  local row = math.floor((vim.api.nvim_win_get_height(0) - height) / 2)
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }
  local win_id = vim.api.nvim_open_win(buf_handle, true, win_config)

  -- Set the window content
  local lines = { "What's new in LazyVim:", body }
  vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, lines)

  -- Focus the window
  vim.api.nvim_set_current_win(win_id)
end, {})
