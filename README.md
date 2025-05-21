# definer.nvim
Quickly look up words based on a key-value json file


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
require("definer").setup({
  definitions_file = "/path/to/my/definitions.json"
})

-- Optional keybind
vim.keymap.set("n", "<C-k>", ":DefinerPopup<CR>", { desc = "Show definition popup" })
vim.keymap.set("n", "<leader>tv", ":DefinerReload<CR>", { desc = "Reload definitions file" })
vim.keymap.set("n", "<leader>tv", ":DefinerAdd<CR>", { desc = "Add definiton for word under cursor" })
```

