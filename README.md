# relative-source.nvim

This [`neovim`](http://neovim.io/) plugin will let you easily source files relative to current script or file.

It's helpful when creating config in a form of a tree spanning across multiple `lua` and `vimrc` files.

## Features

- run scripts at relative (and absolute) paths
- supports `wildcards` and path traversal, like `../path/to/file/*.lua`
- will continue to the next file on error, message about what gone wrong is displayed using `vim.notify()`
- allows easy navigation to listed files using `gf` - you might need to start path with `./` for files in the same directory
- no caching

## Requirements

```
nvim >= 0.5
```

## Installation

### Plugin manager

Any plugin manager should work.

<details open>
  <summary>
    vim-plug:
  </summary>

  ```vim
  Plug 'EtiamNullam/relative-source.nvim'
  ```
</details>

### Manual

Place `relative-source.lua` in directory:

<details open>
  <summary>
    Unix:
  </summary>
    
  ```
  ~/.config/nvim/lua/
  ```
</details>

<details open>
  <summary>
    Windows:
  </summary>
  
  ```
  ~/AppData/Local/nvim/lua/
  ```
</details>

## Usage

### Example

Here you can see how this plugin can be used run config across multiple files.

`init.lua`:
```lua
vim.api.nvim_command [[
  call plug#begin('~/.vim-plug')

    Plug 'EtiamNullam/relative-source.nvim'

  call plug#end()
]]

-- first run will fail here, so you have to invoke ':PlugInstall'
require('relative-source').source {
  'activate-plugins.vimrc',
  'setup-*',
  'plugins/setup-*.lua',
}
```

`activate-plugins.vimrc`:
```vim
call plug#begin('~/.vim-plug')

  Plug 'EtiamNullam/relative-source.nvim'
  Plug 'EtiamNullam/vim-todotxt-syntax'

call plug#end()
```

`setup-vim.vimrc` - example file
```vim
set number
set expandtab
```

`setup-telescope.lua` - example file
```lua
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<Esc>'] = actions.close,
        ['<C-Space>'] = vim.api.nvim_command('stopinsert'),
        ['<C-j>'] = actions.preview_scrolling_down,
        ['<C-k>'] = actions.preview_scrolling_up,
        ['<C-Down>'] = actions.cycle_history_next,
        ['<C-Up>'] = actions.cycle_history_prev,
      },
    },
    path_display = {
      'truncate',
    },
  },
}
```

## Updating

### Versioning

I will try to loosely follow [`Semantic Versioning 2.0`](https://semver.org/spec/v2.0.0.html).

Which means given `major`.`minor`.`patch`:

- `major` will change on API-breaking changes
- `minor` will change on compatible changes
- `patch` will change on bugfixes

### Pinning

Branches `v<major>`, `v<major>.<minor>` and `v<major>.<minor>.<patch>` are available to follow so you don't have to worry about plugin breaking on update.

#### `vim-plug` examples

Pin to specific major version, allowing minor versions and patches to change:

```vim
Plug 'EtiamNullam/relative-source.nvim', { 'branch': 'v0' }
```

Pin to specific minor version, allowing patches to change:

```vim
Plug 'EtiamNullam/relative-source.nvim', { 'branch': 'v0.2' }
```

Pin to specific patch, allowing basically no change:

```vim
Plug 'EtiamNullam/relative-source.nvim', { 'branch': 'v0.2.0' }
```

#### Multiple `plug` blocks

When you have multiple `vim-plug`'s `plug` blocks:

- pin version in the first block if needed
- include in the last block to allow updates

```vim
call plug#begin('~/.vim-plug')

  Plug 'EtiamNullam/relative-source.nvim', { 'branch: 'v0' }

call plug#end()

call plug#begin('~/.vim-plug')

  Plug 'EtiamNullam/relative-source.nvim'

call plug#end()
```
