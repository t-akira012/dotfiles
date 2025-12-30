#!/usr/bin/env bash
NAME=m4mini-prv
sudo scutil --set ComputerName $NAME
sudo scutil --set LocalHostName $NAME
sudo scutil --set HostName $NAME
