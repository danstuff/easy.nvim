#!/bin/bash

function yes_or_no {
    while true; do
        read -p "$* [Y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;  
            [Nn]*) echo "Skipped installing template." ; return  1 ;;
        esac
    done
}

function press_any_key {
    read -n 1 -s -r -p "$1" && echo ;
}

function install {
    sudo yes | cp -rf $1 $2 && echo "Installed $1 to $2"
}

function install_template {
    echo ;
    echo "WARNING: "
    echo "The example config will overwrite any preexisting init.lua or settings.vim files"
    echo "in your config folder."
    echo ;
    press_any_key "Press any key to confirm."
    install template/init.lua ~/.config/nvim/init.lua
    install template/settings.vim ~/.config/nvim/settings.vim
}

install easy.lua ~/.config/nvim/easy.lua
yes_or_no "Would you also like to install the default template?" && install_template
echo "Done."
