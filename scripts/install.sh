#!/bin/bash

######################################
#
# Author: Thomas Bonnet
# Name: install.sh
# Description: Install zsh and all 
# dependencies configured
#
######################################


# Variables
DOTFILE_DIR=$(find / -type d -name 'zsh-dotfiles' 2> /dev/null | head -1)

LOGFILE="/var/log/zshinstall.log"
if [ ! -f "$LOGFILE" ]; then
	touch $LOGFILE
fi

INSTALL_DIR="$HOME/.config/zsh"
if [ ! -d $INSTALL_DIR ]; then
	mkdir -p $INSTALL_DIR
	mkdir -p $INSTALL_DIR/plugins
fi

if [ -f /etc/os-release ]; then
    DISTRI=$(grep "^ID=" /etc/os-release | cut -d'=' -f2 | tr -d '"')
else
    DISTRI=$(cat /etc/*-release | grep "DISTRIB_ID" | sed 's/DISTRIB_ID=//g')
fi

if [[ "$DISTRI" = "Ubuntu" ] || "$DISTRI" = "Debian" ]]; then
	PACKAGE_MNGR="apt-get"; PACKAGE_INSTALL="apt-get install -y"; PACKAGE_UPDATE="apt-get update"; PACKAGE_UPGRADE="apt-get upgrade -y"
elif [[ "$DISTRI" = "redhat" || "$DISTRI" == "centos" || "$DISTRI" == "fedora"]]; then
	PACKAGE_MNGR="dnf"; PACKAGE_INSTALL="dnf install -y"; PACKAGE_UPDATE="dnf update"; PACKAGE_UPGRADE="dnf upgrade -y"
elif [ "$DISTRI" = "arch" ]; then
	PACKAGE_MNGR="pacman"; PACKAGE_INSTALL="pacman -S --noconfirm "; PACKAGE_UPDATE="pacman -Syu"; PACKAGE_UPGRADE="pacman -Syu"
elif [ "$DISTRI" = "alpine" ]; then
	PACKAGE_MNGR="apk"; PACKAGE_INSTALL="apk add"; PACKAGE_UPDATE="apk update"; PACKAGE_UPGRADE="apk upgrade"
fi

# Code

(

echo "===  ZSH installation ==="
echo "===  Date $(date)==="
echo "Distribution: $(DISTRI); Package manager: $(PACKAGE_MNGR)"
echo ""
echo "update and upgrade"
"$PACKAGE_UPDATE"
"$PACKAGE_UPGRADE"
echo ""
if [ ! -d "$HOME/.cache/zsh" ]; then
	echo "$HOME/.cache/zsh is not yet created. Creation..."
	mkdir -p $HOME/.cache/zsh
fi
echo ""
echo "copying files...."
mkdir $INSTALL_DIR/completions
cp $DOTFILE_DIR/zsh/* $INSTALL_DIR && mv $INSTALL_DIR/.zshenv ~/
echo ""
echo "Package installation..."
$PACKAGE_INSTALL zsh-autosuggestions zsh-syntax-highlighting fzf bat tree
curl -sS https://starship.rs/install.sh | sh
echo ""
echo "Plugins installation..."
git clone https://github.com/hlissner/zsh-autopair "$INSTALL_DIR/plugins/zsh-autopair"
echo ""
echo "zsh activation..."
cp $DOTFILE_DIR/starship/starship.toml ~/.config/
chsh -s $(which zsh)

) 1&2> $LOGFILE 
