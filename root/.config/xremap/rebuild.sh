#!/usr/bin/env bash

xremap-ruby $HOME/.config/xremap/map.rb > $HOME/.config/xremap/config.yml

cat <<_EOF_ >> config.yml
keypress_delay_ms: 30
# add
_EOF_

./systemctl_restart
