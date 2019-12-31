#!/bin/bash

RD='\033[1;31m'
LG='\033[1;32m'
YW='\033[1;33m'
LB='\033[1;34m'
NC='\033[0m'

ROOT=~/.config/nvim

# get latest nvim configuration

echo -e "${LB}updating nvim configuration...${NC}"
curl https://raw.githubusercontent.com/bossley9/nvim-config/master/init.vim -o /tmp/init.vim
curl https://raw.githubusercontent.com/bossley9/nvim-config/master/coc-settings.json -o /tmp/coc-settings.json

# install nvim and vim-plug if not already installed

echo -e "${YW}This script will replace any existing version of Neovim. Continue? [Y/N]${NC}"

read bConfirmInstall
if [ $bConfirmInstall == "N"  ] || [ $bConfirmInstall == "n" ]; then
  echo -e "${RD}Unable to install. Aborting.${NC}"
  exit
fi

mkdir -p $ROOT

if grep -q Microsoft /proc/version; then    # WSL
  echo -e "${LB}installing neovim from package manager...${NC}"
  sudo apt-get install --reinstall neovim
else                                        # native linux/unix
  echo -e "${LB}installing neovim from source...${NC}"
  curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o $ROOT/nvim.appimage 
  chmod u+x $ROOT/nvim.appimage

  # replace current nvim executable path
  sudo ln -sfn $ROOT/nvim.appimage /usr/bin/nvim
fi

echo -e "${LB}installing vim-plug...${NC}"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# save any existing nvim configuration

echo -e "${YW}This script will replace any existing init.vim configuration. Save the original? It will be saved as init.vim.bak [Y/N]${NC}"

read bConfirmSave
if [ $bConfirmSave == "N"  ] || [ $bConfirmSave == "n" ]; then
  if test -f $ROOT/init.vim; then mv $ROOT/init.vim $ROOT/init.vim.bak$(date +%M%H%S); fi
fi

# move nvim configuration to configuration directory

mv /tmp/init.vim $ROOT/init.vim
mv /tmp/coc-settings.json $ROOT/coc-settings.json

# install vim-plug plugins

nvim +'PlugInstall --sync' +bd +qa 2>/dev/null

# check version for autocomplete

ver=$(nvim -v | head -1 | cut -d ' ' -f 2 | grep -o '[0-9]\.[0-9]')
autoVer=0.3
if [ $ver \< $autoVer ]; then
  echo -e "${RD}Your version of Neovim is less than the recommended version v$autoVer for Conquer of Completion. Autocomplete may not work as expected.${NC}"
fi

echo -e "${LG}done.${LB} You can now type 'nvim' to start Neovim.${NC}"

