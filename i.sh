#!/usr/bin/env bash

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
    "dotnet-sdk --classic --channel=6.0"
    "intellij-idea-community --classic"
)

declare -a pipx_list=(
    "tox" "twine"
    "black" "flake8"
    # pdm:
    # pdm completion bash \
    # > /etc/bash_completion.d/pdm.bash-completion
    "pdm" "pipenv"
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
    # Not found in brew_install_list:
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
        "dotnet")
            post_install_alert "$1"
            sudo ln -s /snap/dotnet-sdk/current/dotnet /usr/local/bin/dotnet
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

function manual_install_poetry () {
    # curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py \
    # --no-modify-path | python3 -
    # poetry completions bash > /etc/bash_completion.d/poetry.bash-completion
    return
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
    for node_pkg in "${npm_list[@]}"
    do
        if if_no_exe_cmd "$node_pkg"; then
            npm i -g "$node_pkg"
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
    for bottle in "${brew_list[@]}"
    do
        case "$bottle" in
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

function manual_install_perlbrew () {
    if if_no_exe_cmd "perlbrew"; then
        curl -L https://install.perlbrew.pl | bash
        # Sub shell:
        # perlbrew install perl-5.34.0 && perlbrew switch perl-5.34.0
        # tail -f ~/perl5/perlbrew/build.perl-5.34.0.log
    fi
}

function manual_install_nix () {
    if if_no_exe_cmd "nix"; then
        sh <(curl -L https://nixos.org/nix/install) --no-daemon
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

# yes |
# yes | ""
function manual_install_g () {
    if if_no_exe_cmd "g"; then
        # Prevent this script modifying ~/.bashrc
        curl -sSL https://git.io/g-install | sh -s
    fi
}

up_date_grade
add_ppa_repo
apt_install_list
snap_install_list

pip_install_pipx
pipx_install_list

manual_install_nvm
nvm_install_node
npm_install_list

manual_install_brew
brew_install_list

gem_install_list
manual_install_perlbrew
manual_install_nix
manual_install_jabba
manual_install_g
