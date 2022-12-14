#!/usr/bin/env bash

sudo apt install git stow
mkdir -p ~/d; cd ~/d || exit; git clone https://github.com/dj-mc/dev

cd ~ || exit
git clone "https://github.com/dj-mc/.dotfiles.git"
