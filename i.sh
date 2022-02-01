#!/usr/bin/env bash

printf "A post-install script for Ubuntu 20.04 (LTS)\n\n"

# TODO:
# Do not install gnome-tweaks outside of GNOME's DE
# Test this script against Lubutnu w/ LXQt
# Replace snap installs with .deb (or via apt) if possible
# I could optionally install pyenv with brew
# whereis empty?
#   - libsfml-dev
#   - python3-pip
#   - python3.8-venv
#   - qemu
#   - imagemagick
#   - ardour

OS="$OSTYPE"
DE="$XDG_CURRENT_DESKTOP"
printf "%s\n" "Detected $OS and $DE"

declare -a apt_list=(
    "git" "stow" "etckeeper"
    "gnupg" "git-crypt" "git-secret"
    "borgbackup" "pass"
    # --- # --- # --- #
    "curl" "wget"
    "file" "procps" "tree"
    # --- # --- # --- #
    "build-essential"
    "devscripts" "libsfml-dev"
    "clang" "clangd-12"
    "python3-pip" "python3.8-venv"
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
    "ardour" "lmms"
    "supercollider"
)

declare -a snap_list=(
    "discord" "blender --classic"
    "code --classic" "gitkraken --classic"
    "dotnet-sdk --classic --channel=6.0"
    "intellij-idea-community --classic"
)

declare -a pipx_list=(
    "tox" "twine"
    "black" "flake8"
    "pipenv" "poetry"
    "cookiecutter"
    "cmake" "ninja"
    "git-filter-repo"
    "beautysh"
)

declare -a npm_list=(
    "pnpm" "yarn"
    "http-server" "nodemon"
)

declare -a brew_list=(
    "gh" "emacs"
    "shellcheck" "blackbox"
)

function if_lxqt () {
    return
}

function if_gnome () {
    return
}

function not_found_alert () {
    printf "\n%s\n\n" "❌ $1 not found. Attempting to install..."
}

function found_alert () {
    printf "%s\n" "✅ $(whereis "$1")"
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
        "dotnet-sdk")
            post_install_alert "$1"
            sudo snap alias dotnet-sdk.dotnet dotnet
            ;;
    esac
}

### INSTALL ###

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
    for a in "${apt_list[@]}"
    do
        case "$a" in
            "supercollider")
                if if_no_exe_cmd "supernova"; then
                    sudo apt-get -y install "$a"
                fi
                ;;
            *)
                # printf "$(apt-cache policy $a)"
                if ! [ "$(apt-mark showmanual | grep "^$a$")" == "$a" ]; then
                    # Alternative to apt-mark showmanual:
                    # grep "apt-get install" /var/log/apt/history.log
                    not_found_alert "$a"
                    pre_install_options "$a"
                    sudo apt-get -y install "$a"
                    post_install_options "$a"
                else
                    found_alert "$a"
                fi
        esac
    done
    sudo apt-get -y autoremove
}

function snap_install_list () {
    for s in "${snap_list[@]}"
    do
        app=$(awk '{print $1}' <<< "$s")
        if [ "$app" == "dotnet-sdk" ]; then
            app="dotnet"
        fi
        if if_no_exe_cmd "$app"; then
            pre_install_options "$app"
            eval sudo snap install "$s"
            post_install_options "$app"
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
            git checkout \
                `git describe --abbrev=0 --tags --match "v[0-9]*" \
                $(git rev-list --tags --max-count=1)`
        ) && \. "$NVM_DIR/nvm.sh"
        return
    fi
    printf "%s\n" "✅ nvm: $(find ~ -type d -name ".nvm")"
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

function manual_install_brew () {
    if if_no_exe_cmd "brew"; then
        yes "" | /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

function brew_install_list () {
    for b in "${brew_list[@]}"
    do
        case "$b" in
            "blackbox")
                if if_no_exe_cmd "blackbox_cat"; then
                    brew install "$b"
                fi
                ;;
            *)
                if if_no_exe_cmd "$b"; then
                    brew install "$b"
                fi
                ;;
        esac
    done
}

function manual_install_perlbrew () {
    if if_no_exe_cmd "perlbrew"; then
        curl -L https://install.perlbrew.pl | bash
        # Sub shell:
        # perlbrew install perl-5.34.0 && perlbrew switch perl-5.34.0
        # tail -f ~/perl5/perlbrew/build.perl-5.34.0.log
    fi
}

function manual_install_jabba () {
    if [ ! -f ~/.jabba/jabba.sh ]; then
        not_found_alert "jabba"
        export JABBA_VERSION=0.11.2
        curl -sL https://github.com/shyiko/jabba/raw/master/install.sh \
            | bash -s -- --skip-rc && . ~/.jabba/jabba.sh
        jabba install adopt@1.11.0-11 && jabba use adopt@1.11.0-11
    else
        printf "%s\n" "✅ jabba: $(find ~ -type d -name ".jabba")"
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

manual_install_brew
brew_install_list

manual_install_perlbrew
manual_install_jabba
