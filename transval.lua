local M = {}

-- You can change this to load from a JSON or YAML file
-- Example JSON file: {"abc123": "Login Button", "def456": "Search Input"}
local hash_data = {}

-- Load from a file (JSON format)
function M.load_transval_file(filepath)
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
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { info })

    local opts = {
      relative = 'cursor',
      width = math.max(20, #info + 7),
      height = 2,
      col = 0,
      row = 1,
      style = 'minimal',
      border = 'rounded'
    }

    local win = vim.api.nvim_open_win(buf, false, opts)

    -- Create an autocommand to close the window when cursor moves, buffer changes, etc.
    local group = vim.api.nvim_create_augroup("HashPopupAutoClose", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" }, {
      group = group,
      callback = function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end,
      once = true
    })
  else
    print("No info found for: " .. word)
  end
end

function M.setup(config)
  config = config or {}
  if config.transval_file then
    M.load_transval_file(config.transval_file)
  else
    vim.notify("Transval: transval_file not found in config!")
  end

  vim.api.nvim_create_user_command("TransvalPopup", M.show_hash_info, {})
  vim.api.nvim_create_user_command("TransvalReload", function ()
    config = config or {}
    if config.transval_file then
      M.load_transval_file(config.transval_file)
    else
      vim.notify("Transval: transval_file not found in config!")
    end
  end, {})
end

return M
