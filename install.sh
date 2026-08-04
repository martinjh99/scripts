#!/bin/bash
## Source the OS release information file
source /etc/os-release

## Make sure the installer variable points to the right installer for the OS we are running on
case "$ID" in
"opensuse-tumbleweed") INSTALLER="/usr/bin/zypper --non-interactive in" ;;
"fedora") INSTALLER="/usr/bin/dnf install -y" ;;
"ubuntu" | "debian") INSTALLER="/usr/bin/apt install -y" ;;
esac

#Install Needed Software
# If running on Fedora then setup copr repo
if [[ $ID = "fedora" ]]; then
  if [[ ! -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:atim:starship.repo ]]; then
    sudo dnf copr enable atim/starship
  fi
fi

sudo $INSTALLER eza grc starship stow git zsh neovim gcc
#Change User Shell
echo "Enter user password to change shell"
chsh -s /usr/bin/zsh
# clone and install dotfiles
cd ~
git clone https://github.com/martinjh99/dotfiles .dotfiles
cd ~/.dotfiles
stow -v .
cd ~
#Install LazyVim configuration for Neovim
git clone https://github.com/martinjh99/starter .config/nvim
