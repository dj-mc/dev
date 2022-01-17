#!/usr/bin/env bash

printf "A post-install script for Ubuntu 20.04 (LTS)\n\n"

# TODO:
# Do not install gnome-tweaks outside of GNOME's DE
# Detect desktop env, distribution
# Test this script against LXQt and GNOME (debian-based)
# Delete ~/.mozilla/firefox/contents before stow firefox
# Replace snap installs with .deb (or via apt) if possible
# Clone .secrets/.dotfiles and install
# Stow .gitconfig before installing etckeeper
# Stow .nvmrc before installing and using nvm
# I could optionally install pyenv with brew

OS="$OSTYPE"
DE="$XDG_CURRENT_DESKTOP"
printf "Detected $OS and $DE\n"

declare -a apt_list=(
    "git"
    "etckeeper"
    "stow"
    "borgbackup"
    "pass"
    # --- # --- # --- #
    "build-essential"
    "curl"
    "devscripts"
    "file"
    "libsfml-dev"
    "procps"
    "tree"
    # --- # --- # --- #
    "clang"
    "clangd-12"
    "python3-pip"
    "python3.8-venv"
    # --- # --- # --- #
    "gnome-tweaks"
    # --- # --- # --- #
    "vim"
    "xterm"
    "qemu"
    "i3"
    # --- # --- # --- #
    "imagemagick"
    "krita"
    # --- # --- # --- #
    "ffmpeg"
    "cmus"
    "ardour"
    "lmms"
)

declare -a pipx_list=(
    "tox"
    "black"
    "flake8"
    "twine"
    "pipenv"
    "poetry"
    "cookiecutter"
    "cmake"
    "ninja"
    "git-filter-repo"
)

declare -a npm_list=(
    "yarn"
    "http-server"
)

declare -a brew_list=(
    "gh"
    "emacs"
    "shellcheck"
)

function if_kde () {
    return
}

function if_gnome () {
    return
}

function if_lxqt () {
    return
}

function not_found_alert () {
    printf "\n❌ $1 not found. Attempting to install...\n\n"
}

function found_alert () {
    printf "✅ $(whereis "$1")\n"
}

function if_no_exe_cmd () {
    if ! [ -x "$(command -v "$1")" ]; then
        not_found_alert "$1"
        return
    else
        found_alert "$1"
        false
    fi
}

function pre_install_options () {
    return
}

function post_install_options () {
    case "$1" in
        "clangd-12")
            printf "Found clangd-12 as $1"
            sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
            ;;
    esac
}

### INSTALL ###

function up_date_grade () {
    sudo apt-get update
    sudo apt-get dist-upgrade
}

function add_ppa_repo () {
    # Add ppa repo here
    # Then update apt_list
    # sudo apt-get update
    return
}

function apt_install_list () {
    for a in "${apt_list[@]}"
    do
        # printf "$(apt-cache policy $a)"
        if ! [ "$(apt-mark showmanual | grep "^$a$")" ]; then
        # Alternative to apt-mark showmanual:
        # grep "apt-get install" /var/log/apt/history.log
            not_found_alert "$a"
            pre_install_options "$a"
            sudo apt-get install "$a"
            post_install_options "$a"
        else
            found_alert "$a"
        fi
    done
    sudo apt autoremove
}

function snap_install_list () {
    sudo snap install code --classic
    sudo snap install intellij-idea-community --classic
    sudo snap install blender --classic
    sudo snap install discord
}

function pip_install_pipx () {
    if if_no_exe_cmd "pipx"; then
        python3 -m pip install --user pipx
        python3 -m pipx ensurepath
    fi
}

function pipx_install_list () {
    for p in "${pipx_list[@]}"
    do
        if if_no_exe_cmd "$p"; then
            pipx install "$p"
        fi
    done
}

function manual_install_pyenv () {
    if if_no_exe_cmd "pyenv"; then
        curl https://pyenv.run | bash
    fi
}

function manual_install_nvm () {
    if ! [ -f ~/.nvm/nvm.sh ]; then
        not_found_alert "nvm"
        export NVM_DIR="$HOME/.nvm" && (
        git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
        ) && \. "$NVM_DIR/nvm.sh"
        return
    fi
        printf "✅ nvm: $(find ~ -type d -name ".nvm")\n"
}

function nvm_install_node () {
    if if_no_exe_cmd "node"; then
        nvm install
    fi
}

function npm_install_list () {
    for n in "${npm_list[@]}"
    do
        if if_no_exe_cmd "$n"; then
            npm i -g "$n"
        fi
    done
}

function npx_install_pnpm () {
    if if_no_exe_cmd "pnpm"; then
        npx pnpm add -g pnpm
    fi
}

function manual_install_brew () {
    if if_no_exe_cmd "brew"; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

function brew_install_list () {
    for b in "${brew_list[@]}"
    do
        if if_no_exe_cmd "$b"; then
            brew install "$b"
        fi
    done
}

function manual_install_perlbrew () {
    if if_no_exe_cmd "perlbrew"; then
        curl -L https://install.perlbrew.pl | bash
        perlbrew install perl-5.34.0 && perlbrew switch perl-5.34.0
    fi
}

function manual_install_jabba () {
    if [ ! -f ~/.jabba/jabba.sh ]; then
        not_found_alert "jabba"
        export JABBA_VERSION=...
        curl -sL https://github.com/shyiko/jabba/raw/master/install.sh | bash && . ~/.jabba/jabba.sh
        # Remove next line from ~/.profile, keep in ~/.bashrc instead
        # [ -s "/home/dan/.jabba/jabba.sh" ] && source "/home/dan/.jabba/jabba.sh"
        jabba install adopt@1.11.0-11
    else
        printf "✅ jabba: $(find ~ -type d -name ".jabba")\n"
    fi
}

function manual_install_keybase () {
    if if_no_exe_cmd "keybase"; then
        curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
        sudo apt install ./keybase_amd64.deb
        run_keybase
    fi
}

up_date_grade
add_ppa_repo
apt_install_list
snap_install_list

pip_install_pipx
pipx_install_list

manual_install_pyenv

manual_install_nvm
nvm_install_node
npm_install_list
npx_install_pnpm

manual_install_brew
brew_install_list

manual_install_perlbrew
manual_install_jabba

manual_install_keybase
