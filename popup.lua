local M = {}

-- You can change this to load from a JSON or YAML file
-- Example JSON file: {"abc123": "Login Button", "def456": "Search Input"}
local hash_data = {}

-- Load from a file (JSON format)
function M.load_hash_file(filepath)
  local f = io.open(filepath, "r")
  if not f then
    print("Could not open hash file: " .. filepath)
    return
  end
  local content = f:read("*all")
  f:close()

  local ok, parsed = pcall(vim.fn.json_decode, content)
  if ok then
    hash_data = parsed
  else
    print("Failed to parse hash file")
  end
end

-- Main function to show popup
function M.show_hash_info()
  local word = vim.fn.expand("<cword>")
  local info = hash_data[word]

  if info then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Hash: " .. word, "Info: " .. info })
    local opts = {
      relative = 'cursor',
      width = math.max(20, #info + 7),
      height = 2,
      col = 0,
      row = 1,
      style = 'minimal',
      border = 'rounded'
    }
    vim.api.nvim_open_win(buf, false, opts)
  else
    print("No info found for: " .. word)
  end
end

-- Optional toggle command or keymap setup
function M.setup(config)
  config = config or {}
  if config.hash_file then
    M.load_hash_file(config.hash_file)
  end

  vim.api.nvim_create_user_command("ShowHashInfo", M.show_hash_info, {})
end

return M
