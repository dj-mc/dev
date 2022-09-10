#!/usr/bin/env bash

# Update packages and self-update package managers

sudo apt update; sudo apt upgrade -y
nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert
cd ~/spack || exit; git pull
python3 -m pip install --upgrade pip
pip3 install --upgrade pipx
pipx upgrade-all

asdf plugin update --all

npm -g upgrade; npm audit fix
pnpm add -g pnpm

gem update

perlbrew self-upgrade

g self-upgrade
g install latest
g prune
