# Git for Neovim (In Development)

<details>
    <summary>Take a look</summary>
    <img width="1792" alt="Screen Shot 2021-03-26 at 6 51 32 PM" src="https://user-images.githubusercontent.com/25164326/112700485-a4577180-8e64-11eb-9be4-f70ba8aa733c.png">
    <img width="1792" alt="Screen Shot 2021-03-21 at 9 16 08 PM" src="https://user-images.githubusercontent.com/25164326/111928772-efe7d500-8a8a-11eb-854f-b0f4b620d893.png">
</details>

### Provided Features
- [ ] Robust configuration ability
- [x] Hunk signs
- [x] Reset a hunk
- [x] Hunk preview
- [x] Hunk navigation in current buffer
- [x] Show original file and current file in a split window with diffs highlighted
- [x] Telescope plugin to show all files with git changes

### Installation via Plug
```
Plug 'tanvirtin/git.nvim'
```

### Installation via Packer

```
use 'tanvirtin/git.nvim'
```

### Configure Mappings
```
vim.api.nvim_set_keymap("n", '<leader>gh', ':lua require("git").hunk_preview()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", '<leader>gr', ':lua require("git").hunk_reset()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", '<space>]', ':lua require("git").hunk_up()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", '<space>[', ':lua require("git").hunk_down()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", '<leader>.', ':lua require("git").files_changed()<CR>', { noremap = true, silent = true })
```

### API
| Function Name | Description |
|---------------|-------------|
| setup | Sets up the plugin to run necessary git commands on loaded buffers |
| hunk_preview | If a file has a hunk of diff associated with it, invoking this function will reveal that hunk if it exists on the current cursor |
| hunk_reset | Resets the hunk the cursor is on right now to it's previous step
| hunk_down | Navigate downward through a github hunk |
| hunk_up | Navigate upwards through a github hunk |
| files_changed (requires telescope) | Telescopic preview of all the files within the cwd that has a change |

### Config
| Option Name   | Description | Defaults |
|---------------|-------------|----------|
| colors.add | Color when hunk contains all additions | #d7ffaf |
| colors.remove | Color when hunk contains all removals | #e95678 |
| colors.change | Color when hunk contains both addition and deletion | #7AA6DA |
| signs.add | Unique name of the add sign, also dictates highlight group | GitAdd |
| signs.remove | Unique name of the remove sign, also dictates highlight group | GitRemove |
| signs.change | Unique name of the change sign, also dictates highlight group | GitChange |
