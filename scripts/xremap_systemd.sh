#!/usr/bin/env bash

if [[ ! -d $HOME/.config/systemd/user/ ]];then
    mkdir -p $HOME/.config/systemd/user/
fi

cat <<EOF > $HOME/.config/systemd/user/xremap.service
[Unit]
Description=xremap

[Service]
KillMode=process
ExecStart=/home/aki/.cargo/bin/xremap /home/aki/.config/xremap/config.yml
ExecStop=/usr/bin/killall xremap
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user start xremap
systemctl --user enable xremap
