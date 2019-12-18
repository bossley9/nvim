#!/bin/bash

BLE='\033[1;34m'
GRN='\033[1;32m'
NC='\033[0m'

# 1. get latest version of the nvim configuration

echo -e "${BLE}updating nvim configuration...${NC}"

curl -s https://raw.githubusercontent.com/bossley9/nvim-config/master/init.vim -o /tmp/init.vim

# 2. install nvim and vim-plug if not already installed

if ! hash nvim 2>/dev/null; then
  echo -e "${BLE}installing neovim...${NC}"
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install neovim
fi

echo -e "${BLE}installing vim-plug...${NC}"
curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 3. if any nvim configuration already exists, save it

if test -f ~/.config/nvim/init.vim ; then
  mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak$(date +%M%H%S)
fi

# 4. move nvim-config configuration to configuration directory

mkdir -p ~/.config/nvim
mv /tmp/init.vim ~/.config/nvim/init.vim

# install vim-plug plugins

nvim +PlugInstall +qa 2>/dev/null

echo -e "${GRN}done.${BLE} You can now type 'nvim' to start nvim.${NC}"

