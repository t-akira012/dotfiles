#!/usr/bin/env bash

xremap-ruby $HOME/.config/xremap/map.rb > $HOME/.config/xremap/config.yml
./systemctl_restart
