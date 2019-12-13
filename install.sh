#!/bin/bash

# 1. get latest version of the nvim configuration

echo "updating nvim configuration..."

curl https://raw.githubusercontent.com/bossley9/nvim-config/master/init.vim -o /tmp/init.vim

# 2. install nvim and vim-plug if not already installed

if ! hash nvim 2>/dev/null; then
  echo "installing neovim..."
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install neovim
fi


echo "installing vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 3. if any nvim configuration already exists, save it

if test -f ~/.config/nvim/init.vim ; then
  mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak$(date +%M%H%S)
fi

# 4. move nvim-config configuration to configuration directory

mv /tmp/init.vim ~/.config/nvim/

# install vim-plug plugins

nvim +PlugInstall +qa
