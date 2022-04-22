#!/usr/bin/env bash

. ./utilities.sh

printf "A post-install script for Ubuntu 20.04 (LTS)\n\n"

# TODO:
# Make install script for nix
# Do not install gnome-tweaks outside of GNOME's DE
# Test this script against Lubutnu w/ LXQt
# Replace snap installs with .deb (or via apt) if possible
# whereis empty?

OS="$OSTYPE"
DE="$XDG_CURRENT_DESKTOP"
printf "%s\n" "Detected $OS and $DE"

declare -a apt_list=(
    "git" "stow" "etckeeper"
    "gnupg" "git-crypt" "git-secret"
    "borgbackup" "pass"
    # --- # --- # --- #
    "curl" "wget"
    "file" "procps"
    "smem" "tree"
    # --- # --- # --- #
    "libbz2-dev" "libffi-dev" "liblzma-dev"
    "libncursesw5-dev" "libreadline-dev" "libsfml-dev"
    "libsqlite3-dev" "libssl-dev" "libxml2-dev"
    "libxmlsec1-dev" "xz-utils" "zlib1g-dev"
    # --- # --- # --- #
    "build-essential" "clang" "clangd-12" "llvm"
    "python3-pip" "python3.8-venv"
    "devscripts"
    # --- # --- # --- #
    "gnome-tweaks"
    # --- # --- # --- #
    "i3" "qemu"
    "vim" "tmux" "xterm"
    # --- # --- # --- #
    "gthumb" "kdenlive"
    "imagemagick" "krita"
    # --- # --- # --- #
    "cmus" "ffmpeg"
    "mpd" "ardour" "lmms"
    "supercollider"
)

declare -a snap_list=(
    "blender --classic"
    "code --classic" "gitkraken --classic"
    "intellij-idea-community --classic"
)

declare -a pipx_list=(
    "tox" "twine"
    "black" "flake8"
    # pdm:
    # pdm completion bash \
    # > /etc/bash_completion.d/pdm.bash-completion
    "pdm" "poetry"
    "cookiecutter"
    "cmake" "ninja"
    "git-filter-repo"
    "beautysh"
)

declare -a npm_list=(
    "pnpm" "yarn"
    "http-server" "nodemon"
    "npm-check-updates" "cspell"
)

declare -a brew_list=(
    "gh" "emacs"
    "shellcheck" "blackbox"
    "rbenv" "ruby-build"
    "php@8.1"
)

declare -a gem_list=(
    "bundler" "solargraph"
    "rails" "rubocop" "pry"
)

function if_lxqt () {
    return
}

function if_gnome () {
    return
}

function pre_install_alert () {
    printf "%s" "Found pre-install options for $1"
}

function post_install_alert () {
    printf "%s" "Found post-install options for $1"
}

function pre_install_options () {
    return
}

function post_install_options () {
    case "$1" in
        "clangd-12")
            post_install_alert "$1"
            sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
            ;;
    esac
}

function up_date_grade () {
    sudo apt-get -y update
    sudo apt-get -y dist-upgrade
}

function add_ppa_repo () {
    # Add ppa repo here
    # Then update apt_list
    # sudo apt-get update
    return
}

function apt_install_list () {
    for apt_pkg in "${apt_list[@]}"
    do
        case "$apt_pkg" in
            "supercollider")
                if if_no_exe_cmd "supernova"; then
                    sudo apt-get -y install "$apt_pkg"
                fi
                ;;
            *)
                # TOO SLOW
                if ! [ "$(apt-mark showmanual | grep "^$apt_pkg$")" == "$apt_pkg" ]; then
                    # Alternative to apt-mark showmanual:
                    # printf "$(apt-cache policy $apt_pkg)"
                    # grep "apt-get install" /var/log/apt/history.log
                    not_found_alert "$apt_pkg"
                    pre_install_options "$apt_pkg"
                    sudo apt-get -y install "$apt_pkg"
                    post_install_options "$apt_pkg"
                else
                    found_alert "$apt_pkg"
                fi
        esac
    done
    sudo apt-get -y autoremove
}

function snap_install_list () {
    for snap_pkg in "${snap_list[@]}"
    do
        app_name=$(awk '{print $1}' <<< "$snap_pkg")
        if [ "$app_name" == "dotnet-sdk" ]; then
            app_name="dotnet"
        fi
        if if_no_exe_cmd "$app_name"; then
            pre_install_options "$app_name"
            eval sudo snap install "$snap_pkg"
            post_install_options "$app_name"
        fi
    done
}

function pip_install_pipx () {
    if if_no_exe_cmd "pipx"; then
        python3 -m pip install --user pipx
        python3 -m pipx ensurepath
    fi
}

function pipx_install_list () {
    for pip_pkg in "${pipx_list[@]}"
    do
        if if_no_exe_cmd "$pip_pkg"; then
            pipx install "$pip_pkg"
        fi
    done
}

function nvm_install_node () {
    if if_no_exe_cmd "node"; then
        nvm install
    fi
}

function npm_install_list () {
    for node_pkg in "${npm_list[@]}"
    do
        if if_no_exe_cmd "$node_pkg"; then
            npm i -g "$node_pkg"
        fi
    done
}

function brew_install_list () {
    for bottle in "${brew_list[@]}"
    do
        case "$bottle" in
            "php@8.1")
                if if_no_exe_cmd "php"; then
                    brew install "$bottle"
                fi
                ;;
            "blackbox")
                if if_no_exe_cmd "blackbox_cat"; then
                    brew install "$bottle"
                fi
                ;;
            *)
                if if_no_exe_cmd "$bottle"; then
                    brew install "$bottle"
                fi
                ;;
        esac
    done
}

function gem_install_list () {
    for gem_package in "${gem_list[@]}"
    do
        if if_no_exe_cmd "$gem_package"; then
            gem install "$gem_package"
        fi
    done
}

up_date_grade
add_ppa_repo
apt_install_list
snap_install_list

pip_install_pipx
pipx_install_list

nvm_install_node
npm_install_list

brew_install_list

gem_install_list
