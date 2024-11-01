#!/usr/bin/env bash

xremap-ruby $HOME/.config/xremap/map.rb > $HOME/.config/xremap/config.yml
echo 'keypress_delay_ms: 30' >> config.yml

./systemctl_restart
