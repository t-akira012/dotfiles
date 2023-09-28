#!/usr/bin/env bash
set -e

if ! type node >/dev/null 2>&1 ; then
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
