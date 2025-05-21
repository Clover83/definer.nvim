local M = {}

local definition_data = {}
local definitions_file_path = nil

function M.load_definitions_file(filepath)
  local f = io.open(filepath, "r")
  if not f then
    print("Could not open definitions file: " .. filepath)
    return
  end
  local content = f:read("*all")
  f:close()

  local ok, parsed = pcall(vim.fn.json_decode, content)
  if ok then
    definition_data = parsed
    M.definitions_file_path = filepath
  else
    print("Failed to parse definitions file")
  end
end

function M.show_definition()
  local word = vim.fn.expand("<cword>")
  local info = definition_data[word]

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

    local group = vim.api.nvim_create_augroup("DefinerPopupAutoClose", { clear = true })
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

  vim.ui.input({ prompt = "Enter translation for word '" .. word .. "': " }, function(input)
    if input and input ~= "" then
      definition_data[word] = input

      -- Save back to file
      if M.definitions_file_path then
        local f = io.open(M.definitions_file_path , "w")
        if f then
          f:write(vim.fn.json_encode(definition_data))
          f:close()
          print("Saved translation for '" .. word .. "' to file.")
        else
          print("Failed to open file for writing: " .. M.definitions_file_path )
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
  if config.definitions_file then
    M.load_definitions_file(config.definitions_file)
  else
    vim.notify("Definer: definitions_file not found in config!")
  end

  vim.api.nvim_create_user_command("DefinerPopup", M.show_definition, {})
  vim.api.nvim_create_user_command("DefinerAdd", M.add_translation, {})
  vim.api.nvim_create_user_command("DefinerReload", function ()
    config = config or {}
    if config.definitions_file then
      M.load_definitions_file(config.definitions_file)
    else
      vim.notify("Definer: definitions_file not found in config!")
    end
  end, {})
end

return M
