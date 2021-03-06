# NVIM

A modern [Neovim](https://neovim.io/) configuration created to be a more favorable code editor
alternative to Visual Studio Code

![a demonstration of my configuration](demo.gif)

Its features include:

- multi-buffer support (native to vim)
- vim keybindings with additional add-ons (vim-surround, vim-commentary)
- version control support (git gutter)
- file explorer side-pane (nerdtree)
- fuzzy file finding and file searching (fzf and ripgrep)
- automated session saving
- toggleable terminal window (4+ terminal buffers)
- tag navigation and definitions (coc and tsserver plugin(s))
- general syntax, warning, and error highlighting

## Table of Contents

1. [Installation](#installation)
2. [Background](#background)

## Installation <a name="installation"></a>

These instructions work for both Linux distributions and macOS. Windows may require some
tweaking with WSL or puTTY.

1. Install [nodejs](https://nodejs.org/en/download) >= 10.12. This is required by `coc`
   for any sort of language server support:
   ```
   curl -sL install-node.now.sh/lts | bash
   ```
2. Install [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
   for file navigation support. Ripgrep is one of the best
   (in my honest opinion, the very best) line-searching utilities
   for project file searching.
3. Install [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) >= 0.4.
   Certain functions (such as floating buffer windows) will not function properly on
   lower versions.
4. Clone this repository in `$XDG_CONFIG_HOME` (this is usually `~/.config/`).
   ```
   git clone https://github.com/bossley9/nvim.git $XDG_CONFIG_HOME/nvim
   ```
5. Open `neovim`. It should detect the configuration file and immediately
   install all plugins and extensions, then quit.
   ```
   nvim
   ```
6. Reopen `neovim` to ensure all plugins and configuration
   settings are enabled.

If you are running this configuration in MacOS, you will need to enable mouse reporting in your
terminal's preferences to enable mouse support.

## Background <a name="background"></a>

I've used [Visual Studio Code](https://code.visualstudio.com/) for the past few years and it
definitely lives up to its name with beautiful interfaces, built-in language parsing and
wonderful extension library.

But it's lacking a few features that would improve my productivity even further.

First, I have become much more efficient as a developer with vim keybindings. By default,
Visual Studio Code places much more emphasis on aesthetic than development efficiency. I can't
use vim keybindings without a plugin, and even using plugins, it limits the capability of
customizing keybindings.

Even the themes themselves are not as customizable as you'd think. I wanted a semi-opaque
code editor and I wasn't able to implement that in Code, and the only way to make a truly
customized theme is to create one yourself.

But the biggest painpoint of Visual Studio Code is that it hoards resources.

For most machines, this is hardly an issue. But it's the concept that scares me. No code editor
should need to use as much memory as Google Chrome if all it manages are text files. This is a
classic example of "baked-in features that not everyone wants". A code editor should be
minimal, with the option for extensibility as needed.

Not to mention the fact that [its telemetry is extremely creepy](https://stackoverflow.com/questions/40451596/visual-studio-code-still-accessing-internet-after-update-and-telemetry-was-disab).

I wanted an editing solution with high performance and small memory footprint that included
all features I regularly would have used in a code editor. This configuration solves all of
these problems.

#### Vim vs Neovim

I chose Neovim over Vim as a basis due to its out-of-the-box support for gui-related functions
used in the implementation of other features (such as the terminal buffer window). Neovim also
provides consistency across platforms, making it easy to setup on any operating system.

#### How it works

Everything included in this configuration is either an open source plugin of vim or
elementary vimscript hacking. I still consider myself a beginner at vimscript, and I've
included as many comments as necessary in `init.vim` to make each group of logic easier to
understand and easier to modify if desired.
