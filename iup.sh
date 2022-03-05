#!/usr/bin/env bash

sudo apt update; sudo apt upgrade -y
brew update; brew upgrade

python3 -m pip install --upgrade pip
pip3 install --upgrade pipx
pipx upgrade-all

(
    cd "$NVM_DIR"
    git fetch --tags origin
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"
command -v nvm

nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert

npm -g upgrade; npm audit fix
pnpm add -g pnpm

# jabba
# perlbrew
