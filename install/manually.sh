#!/usr/bin/env bash

. ./utilities.sh

function manual_install_nix () {
    if if_no_exe_cmd "nix"; then
        sh <(curl -L https://nixos.org/nix/install) --no-daemon
        . /home/dan/.nix-profile/etc/profile.d/nix.sh
    fi
}

function manual_install_spack () {
    if if_no_which "spack"; then
        cd ~ || exit
        git clone -c feature.manyFiles=true https://github.com/spack/spack.git
    fi
}

function manual_install_asdf_vm () {
    if if_no_which "asdf"; then
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
        # ~/.bashrc:
        # . $HOME/.asdf/asdf.sh
        # . $HOME/.asdf/completions/asdf.bash
    fi
}

function install_ruby_dependencies () {
    sudo apt-get install \
        "autoconf" "bison" "build-essential" \
        "libssl-dev" "libyaml-dev" "libreadline6-dev" \
        "zlib1g-dev" "libncurses5-dev" "libffi-dev" \
        "libgdbm6" "libgdbm-dev" "libdb-dev" "uuid-dev"
}

function asdf_vm_install_plugins () {
    if if_no_exe_cmd "node"; then
        sudo apt-get install dirmngr gpg curl gawk
        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
        asdf install nodejs lts
    fi
    if if_no_exe_cmd "ruby"; then
        install_ruby_dependencies
        asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
        asdf install ruby 3.1.2
    fi
}

function manual_install_perlbrew () {
    if if_no_exe_cmd "perlbrew"; then
        \curl -L https://install.perlbrew.pl | bash
        # Sub shell:
        # perlbrew install perl-5.34.0 && perlbrew switch perl-5.34.0
        # tail -f ~/perl5/perlbrew/build.perl-5.34.0.log
    fi
}

function manual_install_go () {
    if if_no_exe_cmd "go"; then
        return
        # rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
    fi
}

function manual_install_fly_io () {
    if if_no_exe_cmd "fly"; then
        curl -L https://fly.io/install.sh | sh
    fi
}

manual_install_nix
manual_install_spack
manual_install_asdf_vm
asdf_vm_install_plugins
manual_install_perlbrew
# manual_install_go
manual_install_fly_io
