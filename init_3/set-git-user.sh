#!/usr/bin/env bash
set -eu
echo --- SET GIT USER for GLOBAL ---
echo What are you email address?
read email
echo What are you name?
read name
git config --global user.email "$email"
git config --global user.name "$name"

echo user.email is $(git config --global user.email)
echo user.name is $(git config --global user.name)

