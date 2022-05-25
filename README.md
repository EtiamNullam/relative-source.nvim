# relative-source.nvim

This `neovim` plugin will let you easily source files relative to current script or to current file if not running in a script.

It's useful for creating structurized config spanning across multiple `lua` and `vimrc` files.

### Compared to `lua require()`:
- no caching
- relative paths
- no surprises

## Requirements

```
nvim >= 0.5
```

## Installation

### Plugin manager

- Using `vim-plug`:

  ```viml
  Plug 'EtiamNullam/relative-source.nvim'
  ```

### Manual

Place `relative-source.lua` in directory:
- Unix:
  ```
  ~/.config/nvim/lua/
  ```
- Windows:
  ```
  ~/AppData/Local/nvim/lua/
  ```

## Usage
  - `lua`

    ```lua
    require('relative-source').source_files {
      'activate-plugins.vimrc',
      'setup-colorscheme.lua',
      'plugins/configure-lsp.lua',
    }
    ```
  - `vimrc`

    ```viml
    lua <<END
      require('relative-source').source_files {
        'activate-plugins.vimrc',
        'setup-colorscheme.lua',
        'plugins/configure-lsp.lua',
      }
    END
    ```
    
### Notes:
- There can be no indent or characters on the same line preceding `END`.
- You can use `gf` to go to selected file.
