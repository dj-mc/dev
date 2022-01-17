#!/usr/bin/env bash

command -v brew

command -v perlbrew

command -v pipx

command -v pipenv

command -v pyenv

command -v keybase

source ~/.jabba/jabba.sh
printf "$(command -v jabba) $(jabba --version)\n"

source ~/.nvm/nvm.sh
printf "$(command -v nvm) $(nvm --version)\n"
