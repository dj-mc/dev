#!/usr/bin/env bash

command -v brew

command -v perlbrew

command -v pipx

command -v pipenv

command -v pyenv

source ~/.jabba/jabba.sh
printf "%s\n" "$(command -v jabba) $(jabba --version)"

source ~/.nvm/nvm.sh
printf "%s\n" "$(command -v nvm) $(nvm --version)"
