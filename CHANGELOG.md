# Changelog

## Unreleased

## [1.1.0](https://github.com/bossley9/nvim-config/releases/tag/v1.1.0) - 2019-12-30

### Added
- warning for low Neovim versions < 0.3
- `<C-s>` keymap to write files
- `<BS>` keymap to delete characters in visual mode
- airline tab theme

### Changed
- 4 space tabs to 2 space tabs
- install script to install from source on linux/unix and to install from package manager on WSL
- install script ask before replacing init.vim configuration
- theme from onedark to edge 
- ctermbg to redraw more accurately in WSL
- terminal toggle to delete terminal buffer on exit instead of closing
- spelling and captialization
- window title to include folder name, then file name
- gutter highlight to match background
- no highlight to be called silently
- session to only save if opened with directory

### Removed
- changing buffer tabs from terminal window
- mode line below statusline
- project directory name from the tabline
- old neoterm settings
- line number and gutter from terminal

## [1.1.0](https://github.com/bossley9/nvim-config/releases/tag/v1.1.0) - 2019-12-28

### Added
- Neoclide/coc autocompletion for web development languages
- Coc settings

### Changed
- `<Tab>` keymap to trigger autocompletion first, then emmet

## [1.0.0](https://github.com/bossley9/nvim-config/releases/tag/v1.0.0) - 2019-12-27

### Added
- Initial configuration
- Install script
- Readme
- Changelog

### Changed
- install script to close plugin buffer
- Changelog to include link for v1.0.0
