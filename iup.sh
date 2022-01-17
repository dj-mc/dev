#!/usr/bin/env bash

sudo apt update; sudo apt upgrade -y
brew update; brew upgrade

python3 -m pip install --upgrade pip
pip3 install --upgrade pipx
pipx upgrade-all

cd ~/.pyenv || exit; git pull

(
  cd "$NVM_DIR"
  git fetch --tags origin
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
command -v nvm

npm -g upgrade; npm audit fix
pnpm add -g pnpm
