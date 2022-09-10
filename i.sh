#!/usr/bin/env bash

. ./apt-get.sh
. ./utilities.sh

printf "A post-install script for Ubuntu jammy (LTS)\n\n"

OS="$OSTYPE"
DE="$XDG_CURRENT_DESKTOP"
printf "%s\n" "Detected $OS and $DE"

declare -a pipx_list=(
    "tox" "twine"
    "black" "flake8"
    # pdm:
    # pdm completion bash \
    # > /etc/bash_completion.d/pdm.bash-completion
    "cookiecutter"
    "pdm" "poetry"
    "cmake" "ninja"
    "git-filter-repo"
    "beautysh"
)

declare -a npm_list=(
    "pnpm" "yarn"
    "http-server" "json-server" "nodemon"
    "npm-check-updates" "cspell"
)

declare -a gem_list=(
    "bundler" "solargraph"
    "rails" "rubocop" "pry"
)

function pip_install_pipx () {
    if if_no_exe_cmd "pipx"; then
        python3 -m pip install --user pipx
        python3 -m pipx ensurepath
    fi
    # Added /home/dan/.local/bin to the PATH
    # Run 'pipx completions' for completions
}

function pipx_install_list () {
    for pip_pkg in "${pipx_list[@]}"
    do
        if if_no_exe_cmd "$pip_pkg"; then
            pipx install "$pip_pkg"
        fi
    done
}

function npm_install_list () {
    for node_pkg in "${npm_list[@]}"
    do
        if if_no_exe_cmd "$node_pkg"; then
            npm i -g "$node_pkg"
        fi
    done
}

function gem_install_list () {
    for gem_pkg in "${gem_list[@]}"
    do
        if if_no_exe_cmd "$gem_pkg"; then
            gem install "$gem_pkg"
        fi
    done
}

up_date_grade
# add_ppa_repo
apt_install_list

pip_install_pipx
pipx_install_list

npm_install_list

gem_install_list
