#!/usr/bin/env bash

# Run like this:
# bash https://github.com/dj-mc/dev/setup.sh <key>

key=$1
printf "%s" "$key"

sudo apt install git stow
mkdir -p ~/d; cd ~/d || exit; git clone https://github.com/dj-mc/dev

cd ~ || exit
git clone "https://$key@github.com/dj-mc/.dotfiles.git"
