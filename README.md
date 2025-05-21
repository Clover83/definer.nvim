# definer.nvim
Quickly look up words based on a key-value json file

## Installation Instructions
### Lazy
```lua
{
  "Clover83/definer.nvim"
}

```

## Example Usage 
Create a json file:
```json
{
  "abc123": "Login Button",
  "def456": "Search Input",
  "ghi789": "Submit Form"
}
```

Add to your config:
```lua
require("definer").setup({
  definitions_file = "/path/to/my/definitions.json"
})

-- Optional keybind
vim.keymap.set("n", "<C-k>", ":DefinerPopup<CR>", { desc = "Show definition popup" })
vim.keymap.set("n", "<leader>tv", ":DefinerReload<CR>", { desc = "Reload definitions file" })
vim.keymap.set("n", "<leader>ta", ":DefinerAdd<CR>", { desc = "Add definiton for word under cursor" })
```


## TODO
- [ ] Actual plugin configuration
- [ ] Dynamically change definitions file
- [ ] More viewing options, e.g. virtual lines
- [ ] Telescope support
