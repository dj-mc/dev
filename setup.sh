#!/usr/bin/env bash

key=$1
printf "%s" "$key"

sudo apt install git stow

mkdir ~/d; cd ~/d; git clone https://github.com/dj-mc/dev

cd ~
git clone "https://$key@github.com/dj-mc/.secrets.git"
git clone https://github.com/dj-mc/.dotfiles.git
