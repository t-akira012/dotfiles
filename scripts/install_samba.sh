#!/usr/bin/env bash


if type samba >/dev/null 2>&1;then
  sudo systemctl status smbd.service
  exit 0
fi

USER=$(whoami)
sudo apt update -y
sudo apt install samba

sudo systemctl enable smbd
sudo systemctl enable nmbd
sudo systemctl start smbd
sudo systemctl start nmbd


cat <<EOF | sudo tee -a /etc/samba/smb.conf

[storage]
comment = Storage
path = /mnt/storage
writable = yes
guest ok = No
guest only = No
force user = $USER
EOF

sudo smbpasswd -a $USER
sudo smbpasswd -e $USER

sudo systemctl enable smbd.service
sudo systemctl start smbd.service
