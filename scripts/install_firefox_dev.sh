#!/usr/bin/env bash
set -e

FIREFOX_LANG=ja

download(){
  wget "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=${FIREFOX_LANG}" -O Firefox-dev.tar.bz2
  sudo tar xjf Firefox-dev.tar.bz2 -C /opt/
  rm -f Firefox-dev.tar.bz2
}

install(){
  sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox-dev
  cat <<EOF | sudo tee /usr/share/applications/Firefox-dev.desktop
[Desktop Entry]
Name=Firefox-developer-edition
Exec=/usr/local/bin/firefox-dev
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
comment=browser
Type=Application
Terminal=false
Encoding=UTF-8
Categories=Utility;
EOF

sudo update-desktop-database
}


if [[ ! -e /opt/firefox/firefox ]];then
  download
  install
else
  download
  echo update finished.
fi

