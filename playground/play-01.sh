#!/usr/bin/env bash

function user_info() {
    echo "Welcome, $USER"
    echo "Your uptime: $(uptime | awk '{print $3, $4}')"

    echo "Today is: $(date), Week is: $(date +"%V")/52"
    echo

    printf "Logged in users: %s\n" \
        "$(w | cut -d " " -f1 - | grep -v USER)"
    echo

    echo "Using $(uname -s) on $(uname -m) architecture"
}

function init_scripts() {
    man init || man systemd

    printf "/etc/init.d/ has: "
    printf "$(find /etc/init.d/ | wc -l) %s\n" "files or dirs"
    printf "/etc/systemd/system/ has: "
    printf "$(find /etc/systemd/system/ | wc -l) %s\n" "files or dirs"
}

function usr_bin_bash_info() {
    echo "Where is bash: $(whereis bash | awk '{print $2}')"
    echo "Version of bash: $(bash --version | head -n1)"
}

user_info
init_scripts
usr_bin_bash_info
