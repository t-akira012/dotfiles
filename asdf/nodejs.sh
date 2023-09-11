#!/usr/bin/env bash
set -e

if ! type node; then
    asdf plugin add nodejs
    asdf install nodejs latest
    asdf global nodejs latest
fi

npm i -g npm yarn

echo node version
node -v
echo npm version
npm -v
echo yarn version
yarn -v

echo done.
