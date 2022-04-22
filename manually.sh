#!/usr/bin/env bash

. ./utilities.sh

function manual_install_alda () {
    if if_no_exe_cmd "alda"; then
        mkdir -p ~/.alda/bin
        wget -P ~/.alda/bin https://alda-releases.nyc3.digitaloceanspaces.com/2.2.0/client/linux-amd64/alda
        wget -P ~/.alda/bin https://alda-releases.nyc3.digitaloceanspaces.com/2.2.0/player/non-windows/alda-player
        chmod +x ~/.alda/bin/{alda,alda-player}
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

function manual_install_brew () {
    if if_no_exe_cmd "brew"; then
        yes "" | /bin/bash -c \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
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

manual_install_alda
manual_install_nvm
manual_install_brew
manual_install_perlbrew
manual_install_nix
manual_install_jabba
manual_install_g
