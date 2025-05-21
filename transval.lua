local M = {}

-- You can change this to load from a JSON or YAML file
-- Example JSON file: {"abc123": "Login Button", "def456": "Search Input"}
local hash_data = {}
local transval_file_path = nil

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
    M.transval_file_path = filepath
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

function M.add_translation()
  local word = vim.fn.expand("<cword>")
  if not word or word == "" then
    print("No word under cursor.")
    return
  end

  -- Prompt for the translation
  vim.ui.input({ prompt = "Enter translation for hash '" .. word .. "': " }, function(input)
    if input and input ~= "" then
      hash_data[word] = input

      -- Save back to file
      if M.transval_file_path then
        local f = io.open(M.transval_file_path, "w")
        if f then
          f:write(vim.fn.json_encode(hash_data))
          f:close()
          print("Saved translation for '" .. word .. "' to file.")
        else
          print("Failed to open file for writing: " .. M.transval_file_path)
        end
      else
        print("No file path set. Cannot save persistently.")
      end
    else
      print("Translation canceled.")
    end
  end)
end

function M.setup(config)
  config = config or {}
  if config.transval_file then
    M.load_transval_file(config.transval_file)
  else
    vim.notify("Transval: transval_file not found in config!")
  end

  vim.api.nvim_create_user_command("TransvalPopup", M.show_hash_info, {})
  vim.api.nvim_create_user_command("TransvalAdd", M.add_translation, {})
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
