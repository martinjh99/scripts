#!/usr/bin/env bash
## Source the OS release information file

function help {
  echo -e "\x1b[1;32mMartins Installer and PC Setup\x1b[1;34m"
  echo -e "\r"
  echo " -e - install everything"
  echo " -a - Install apps only"
  echo -e " -c - clone configuration"
  echo -e " -h - Help\x1b[0m"
  echo -e "\r\r"
  return 0
}

function install-apps {

  #sourcing this file gives me environment variables about the installed operating system
  source /etc/os-release

  # check the ID of the installed operating system and set installer as required
  case "$ID" in
  "opensuse-tumbleweed")
    INSTALLER="/usr/bin/zypper --non-interactive in"
    APPS="eza grc starship stow git zsh neovim gcc"
    ;;
  "fedora")
    INSTALLER="/usr/bin/dnf install -y"
    APPS="eza grc starship stow git zsh neovim gcc"
    ;;
  "ubuntu")
    INSTALLER="/usr/bin/apt install -y"
    APPS="eza grc stow git zsh neovim gcc"
    ;;
  esac
  # If running on Fedora then setup copr repo
  if [[ $ID = "fedora" ]]; then
    if [[ ! -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:atim:starship.repo ]]; then
      sudo dnf copr enable atim/starship
    fi
  fi
  sudo $INSTALLER $APPS
}

function install-config {
  source /etc/os-release
  clear #Change User shell
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
}

if [ -z "$1" ]; then
  CHOICE=$(dialog --clear \
    --backtitle "Martins Installer 0.5-dialog" \
    --title "Main Menu" \
    --menu "Please select an option: " 0 0 4 \
    1 "Install Everything" \
    2 "Install Apps Only" \
    3 "Clone Configurations and change shell" \
    2>&1 >/dev/tty)
  #    echo $CHOICE
  case $CHOICE in
  "1")
    install-apps
    install-config
    ;;
  "2") install-apps ;;
  "3") install-config ;;
  esac

fi

while getopts "aceh" opt; do
  case $opt in
  e)
    install-apps
    install-config
    ;;
  c) install-config ;;
  a) install-apps ;;
  h) help ;;
  *) echo "Invalid Flags" ;;
  esac
done
