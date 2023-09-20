if [[ ! -e "~/.local/share/gnome-shell/extensions/xremap@k0kubun.com" ]]
    git clone https://github.com/xremap/xremap-gnome ~/.local/share/gnome-shell/extensions/xremap@k0kubun.com
fi

if ! type xremap 2>&1 ;then
    cargo install xremap --features gnome
fi

if ! type xremap-ruby 2>&1 ;then
    gem install xremap
fi

if [[ -z $(lsmod | grep uinput) ]];then
    echo uinput | sudo tee /etc/modules-load.d/uinput.conf
fi

if [[ ! -f "/etc/udev/rules.d/input.rules" ]];then
    sudo gpasswd -a $(whoami) input
    echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
fi

read -p "reboot済みならenter"
sudo modprobe uinput
sudo udevadm control --reload-rules && sudo udevadm trigger
