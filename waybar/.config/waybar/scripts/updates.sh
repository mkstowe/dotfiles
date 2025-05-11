#!/bin/bash

if [ ! -f /etc/arch-release ] ; then
    exit 0
fi

pkg_installed() {
    local PkgIn=$1

    if pacman -Qi "$PkgIn" &> /dev/null
    then
        echo "Found"
    else
        echo "Not found"
    fi
}

aur=`yay -Qua | wc -l`
ofc=`pacman -Qu | wc -l`

upd=$(( aur + ofc ))

if [ $upd -eq 0 ] ; then
    echo "{\"text\":\"\", \"tooltip\":\" Packages are up to date\", \"class\":\"empty\"}"
else
    echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur\", \"class\":\"empty\"}"
fi

if [ "$1" == "up" ] ; then
    kitty sh -c "yay -Syu"
fi
