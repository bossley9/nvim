# nvim
A modern [Neovim](https://neovim.io/) configuration

## Table of Contents
1. [Installation](#installation)
2. [About](#about)
3. [Todo](#todo)

## Installation <a name="installation"></a>
1. Verify [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) 
    is installed.
2. Clone this repository in `$XDG_CONFIG_HOME` (this is usually `~/.config/`).
    ```
    git clone https://github.com/bossley9/nvim.git
    ```
3. Open `neovim`. It should detect the configuration file and immediately 
    install all plugins.
4. Close and reopen `neovim` to ensure all plugins and configuration 
    settings are enabled.

If future updates are made to this configuration, pulling the latest commits 
and opening `neovim` will automatically install any new plugins.

## About <a name="about"></a>

### Problem

I have used [Visual Studio Code](https://code.visualstudio.com/) for the past 
few years and I've enjoyed many of its features and extensions; however, it 
takes a large toll on memory 
([and telemetry is creepy](https://stackoverflow.com/questions/40451596/visual-studio-code-still-accessing-internet-after-update-and-telemetry-was-disab)).

I wanted an editing solution with high performance and small memory footprint 
that includes all the features of Visual Studio Code that I regularly utilize.

### Solution

Vim and its Neovim counterpart are low-level text editors that focus soley on 
what they were designed to do - edit files. Neovim has no discernible impact on 
performance or memory, and the keybindings and shortcuts allow the user to keep 
their hands near the keyboard, improving actual editing efficiency. I chose 
Neovim over Vim due to its out-of-the-box support for gui-related features and 
other features I used in VS Code (such as the in-editor terminal). Neovim also 
has consistency across platforms, making it easy to setup on any operating system.

## Todo <a nane="todo"></a>

- terminal buffer system
- `set viminfo=""` to prevent viminfo creation
