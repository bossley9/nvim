#!/bin/bash

RD='\033[1;31m'
LG='\033[1;32m'
YW='\033[1;33m'
LB='\033[1;34m'
NC='\033[0m'

ROOT=~/.config/nvim

# get latest nvim configuration

echo -e "${LB}updating nvim configuration...${NC}"
curl -s https://raw.githubusercontent.com/bossley9/nvim-config/master/init.vim -o /tmp/init.vim

# install nvim and vim-plug if not already installed

echo -e "${YW}This script will replace any existing version of Neovim. Continue? [Y/N]${NC}"

read bConfirmInstall
case $bConfirmInstall in
  [Nn]*) echo -e "${RD}Unable to install. Aborting.${NC}"; exit;
esac

echo -e "${LB}installing neovim from source...${NC}"

mkdir -p $ROOT
  
curl -Ls https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o $ROOT/nvim.appimage 
chmod u+x $ROOT/nvim.appimage

echo -e "${LB}installing vim-plug...${NC}"
curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# save any existing nvim configuration

if test -f ~/.config/nvim/init.vim; then mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak$(date +%M%H%S); fi

# move nvim configuration to configuration directory

mv /tmp/init.vim $ROOT/init.vim

# replace current nvim executable path

sudo ln -sfn $ROOT/nvim.appimage /usr/bin/nvim

# install vim-plug plugins

nvim +'PlugInstall --sync' +bd +qa 2>/dev/null

echo -e "${LG}done.${LB} You can now type 'nvim' to start Neovim.${NC}"

