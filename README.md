# nvim-config
A modern [Neovim](https://neovim.io/) configuration

## Table of Contents
1. [Installation/Setup](#setup)
2. [About](#about)
3. [Changelog](#changelog)

## Installation/Setup <a name="setup"></a>
1. Run the `install.sh` script file.
    This will install the latest version of Neovim and [`Vim-Plug`](https://github.com/junegunn/vim-plug).
    This will also install all plugins and update any existing nvim configuration settings.
    ```bash
    curl -s https://raw.githubusercontent.com/bossley9/nvim-config/master/install.sh | bash 
    ```
    If future updates are made to this nvim configuration, rerun this script to pull the latest updates and install them automatically.

2. Run `nvim` to open any file.

## About <a name="about"></a>

### Problem

I have used [Visual Studio Code](https://code.visualstudio.com/) for the past few years and I've enjoyed many of its features and extensions; however, it takes a large toll on memory ([and telemetry is creepy](https://stackoverflow.com/questions/40451596/visual-studio-code-still-accessing-internet-after-update-and-telemetry-was-disab)).

I wanted an editing solution with high performance and small memory footprint that includes all the features of Visual Studio Code that I regularly utilize.

### Solution

Vim and its Neovim counterpart are low-level text editors that focus soley on what they were designed to do - edit files. I chose to use Neovim as a solution because it has no discernible impact on performance and memory.

I agree with many people that the user interfaces of both Vim and Neovim are very basic, which is why I scoured the internet looking for plugins and add-ons that made the most sense to add to Neovim. These plugins make it easier for a VS Code user to transition to Neovim in the most friendly fashion.

This configuration of nvim is something I use in order to improve my speed and efficiency while editing code projects.

### Why Neovim over Vim?

I chose to use Neovim over Vim due to its out-of-the-box support for gui-related features and other features I used in VS Code (such as the in-editor terminal).

## Changelog <a name="changelog"></a>

See [changelog](CHANGELOG.md).
