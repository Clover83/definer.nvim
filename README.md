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
require("transval").setup({
  transval_file = "/path/to/my/translation.json"
})

-- Optional keybind
vim.keymap.set("n", "<C-k>", ":TransvalPopup<CR>", { desc = "Show hash popup" })
vim.keymap.set("n", "<leader>tv", ":TransvalReload<CR>", { desc = "Reload translation file" })
```

