#!/usr/bin/env bash
set -eux

gnome(){
  if [[ ! -e "~/.local/share/gnome-shell/extensions/xremap@k0kubun.com" ]];then
      git clone https://github.com/xremap/xremap-gnome ~/.local/share/gnome-shell/extensions/xremap@k0kubun.com
  fi

  if ! type xremap 2>&1 ;then
      cargo install xremap --features gnome
  fi
}

kde(){
  if ! type xremap 2>&1 ;then
      cargo install xremap --features kde
  fi
}
x11(){
      cargo install xremap --features x11
}

if [[ $XDG_SESSION_TYPE == "KDE" ]];then
  x11
elif [[ $XDG_CURRENT_DESKTOP == "KDE" ]];then
  kde
elif [[ $XDG_CURRENT_DESKTOP == "Gnome" ]];then
  gnome
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
