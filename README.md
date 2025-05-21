# transval.nvim
Quickly look up words based on a key-value file


# Example Usage 
Create a json file:
```json
{
  "abc123": "Login Button",
  "def456": "Search Input",
  "ghi789": "Submit Form"
}
```

```lua
require("hash_popup").setup({
  hash_file = "/path/to/your/hashes.json"
})

-- Optional keybind
vim.keymap.set("n", "<leader>hh", ":ShowHashInfo<CR>", { desc = "Show hash popup" })
```

