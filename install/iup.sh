#!/usr/bin/env bash

# Update packages and self-update package managers

sudo apt update; sudo apt upgrade -y
nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert

python3 -m pip install --upgrade pip
pip3 install --upgrade pipx
pipx upgrade-all

perlbrew self-upgrade

asdf plugin update --all

npm -g upgrade; npm audit fix
pnpm add -g pnpm

gem update
