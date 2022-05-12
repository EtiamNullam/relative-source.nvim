# relative-source.nvim

## Description

  This plugin will let you easily source `lua` and `vimrc` files relative to current script (or to current file if not running in a script).

  Compared to using `lua require()`:
  - no caching
  - relative paths
  - no surprises

## Requirements

  `nvim >= 0.5`

## Installation

### Plugin Manager

#### Example using vim-plug:

  ```viml
  Plug 'EtiamNullam/relative-source.nvim'
  ```

### Manual

#### Windows

  Place `relative-source.lua` in directory `~/AppData/Local/nvim/lua/`

#### Unix

  Place `relative-source.lua` in directory `~/.config/nvim/lua/`

## Usage

### vimrc:

  ```viml
  lua <<END
    require('relative-source').source_files {
      'activate-plugins.vimrc',
      'setup-colorscheme.lua',
      'plugins/configure-lsp.lua',
    }
  END
  ```

### lua:

  ```lua
  require('relative-source').source_files {
    'activate-plugins.vimrc',
    'setup-colorscheme.lua',
    'plugins/configure-lsp.lua',
  }
  ```

  NOTES:
  - Lines `lua <<END` and `END` are only necessary when ran from `vimrc` file and need to be skipped in `lua` file. 
  - There can be no indent or characters on the same line preceding `END`.
  - You can use `gf` to go to file
