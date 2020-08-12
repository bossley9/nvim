# NVIM
A modern [Neovim](https://neovim.io/) configuration

## Table of Contents
1. [Installation](#installation)
2. [About](#about)
3. [Todo](#todo)

## Installation <a name="installation"></a>
1. Verify [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) 0.4+
    is installed. Certain functions available will not function properly on lower
    versions.
2. Clone this repository in `$XDG_CONFIG_HOME` (this is usually `~/.config/`).
    ```
    git clone https://github.com/bossley9/nvim.git $XDG_CONFIG_HOME/nvim
    ```
3. Open `neovim`. It should detect the configuration file and immediately 
    install all plugins.
4. Close and reopen `neovim` to ensure all plugins and configuration 
    settings are enabled.

If future updates are made to this configuration, pulling the latest commits 
and opening `neovim` will automatically install any new plugins.

**While almost everything is automated by install, Coc extensions need to be installed 
manually**. Coc is the best alternative for auto completion, auto imports, defintions,
tag searching, etc for Typescript.

You can install Coc extensions with the command `:CocInstall extName`. Below are a list of
extensions I always install:
- `coc-css`
- `coc-json`
- `coc-tsserver`

If you are running this in iterm in OSX, you will need to enable mouse reporting
in iterm's preferences in order to have mouse support.

## About <a name="about"></a>

### Problem

I have used [Visual Studio Code](https://code.visualstudio.com/) for the past 
few years and I've enjoyed many of its features and extensions; however, it 
takes a large toll on memory 
([and telemetry is creepy](https://stackoverflow.com/questions/40451596/visual-studio-code-still-accessing-internet-after-update-and-telemetry-was-disab)).

I've also grown accustomed to [Vim](https://www.vim.org/) keybindings. They are 
short, efficient, and prevent the user from leaving the keyboard, saving 
precious seconds of time. I've tried to use Visual Studio Code's `vim` and 
`neovim` extensions and am dissatisfied with both. They both display the mode 
on the status bar which is hidden in ~~`fullscreen` and~~ `zen mode` (both of which 
I use frequently). ~~They also seem to have occassional glitches, and not all 
Vim commands can be executed.~~ _I was experiencing glitches and issues due to
Vim plugin incompatiblity with Visual Studio Code (my own ignorance). However, my
argument still stands._

I wanted an editing solution with high performance and small memory footprint 
that includes all the features of Visual Studio Code that I regularly utilize.

### Solution

Vim and its Neovim counterpart are low-level text editors that focus soley on 
what they were designed to do - edit files. Neovim has no discernible impact on 
performance or memory, and the keybindings and shortcuts improve editing 
efficiency. while some would argue that Neovim and Vim are essentially identical,
I chose Neovim over Vim due to its out-of-the-box support for gui-related features and 
other features I used in VS Code (such as the in-editor terminal). Neovim also 
has consistency across platforms, making it easy to setup on any operating system.

## Todo <a nane="todo"></a>

- no todos!
