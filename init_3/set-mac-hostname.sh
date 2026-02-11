#!/usr/bin/env bash
read -p "Enter hostname: " NAME
sudo scutil --set ComputerName $NAME
sudo scutil --set LocalHostName $NAME
sudo scutil --set HostName $NAME
