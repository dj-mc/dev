#!/usr/bin/env bash

. ./utilities.sh

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

declare -a apt_list=(
    "git" "stow"
    "7zip" "borgbackup" "pass"
    "curl" "smem" "tree"
    "build-essential" "clang" "clangd" "llvm"
    "python3-pip" "python3.10-venv"
    # --- # --- # --- #
    # "git-crypt" "git-secret"
    # --- # --- # --- #
    # "libbz2-dev" "libffi-dev" "liblzma-dev"
    # "libncursesw5-dev" "libreadline-dev" "libsfml-dev"
    # "libsqlite3-dev" "libssl-dev" "libxml2-dev"
    # "libxmlsec1-dev" "xz-utils" "zlib1g-dev"
    # --- # --- # --- #
    # "emacs"
    # "devscripts"
    # --- # --- # --- #
    "gnome-tweaks"
    # --- # --- # --- #
    "i3" "qemu"
    "tmux" "vim" "xterm"
    "shellcheck" "zsh"
    # --- # --- # --- #
    # "kdenlive" "krita"
    # --- # --- # --- #
    # "cmus" "lmms"
    # "supercollider"
)

function apt_install_list () {
    FOUND_NEW_PKG=false
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

                    FOUND_NEW_PKG=true
                    not_found_alert "$apt_pkg"
                    sudo apt-get -y install "$apt_pkg"
                else
                    found_alert "$apt_pkg"
                fi
        esac
    done
    if [ "$FOUND_NEW_PKG" = true ]; then
        sudo apt-get -y autoremove
    fi
}
