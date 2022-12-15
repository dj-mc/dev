#!/usr/bin/env bash

function list_shells() {
    cat /etc/shells
    # Useless use of `cat`
    cat /etc/passwd | grep dan
}

function interactive_shell() {
    # Invocations
    # An interactive shell reads/writes to a user's terminal

    # Interactive login shell
    # Reads from the following files
    cat ~/.profile
    cat ~/.bash_logout
    cat /etc/profile

    # When invoked with `sh`
    # Same as above, but without ~/.bash_logout
}

function non_interactive() {
    # Interactive non-login shell
    # Only reads from
    cat ~/.bashrc

    # All scripts use non-interactive shells
    # Non-interactive shells read from:
    # echo "$BASH_ENV"
}

function check_interactive() {
    # Is it interactive?
    echo $-
}

function posix_mode() {
    # Set POSIX mode
    # set -o posix

    # Check if in POSIX mode
    set -o | grep posix

    # POSIX mode shells read from:
    # echo "$ENV"
}

function directory_stack() {
    # Directory stack
    pushd ~ || exit
    pushd /etc || exit
    pushd ..
    popd || exit
    popd || exit
    popd || exit
}

# Attempts at getting function names from this file:
# grep "^function" "$0"
# typeset -f | awk '/ \(\) / {print $1}'
# typeset -f | awk '/ \(\) $/ && !/^main / {print $1}'
# declare -F | awk '{print $NF}'

# Alphabetical order, not declared order
# for func in $(declare -F | awk '{print $3}'); do
#     clear
#     ${func}
#     printf "\nEnd of function call: %s\n" "${func}"
#     read -n1 -s -r -p "Press a key to continue"
#     printf "\n"
#     clear
# done

declare -a execute_these=(
    list_shells
    interactive_shell
    non_interactive
    check_interactive
    posix_mode
    directory_stack
)

function main() {
    for func in "${execute_these[@]}"; do
        clear
        ${func}
        printf "\nEnd of function call: %s\n" "${func}"
        read -n1 -s -r -p "Press a key to continue"
        printf "\n"
        clear
    done
}

main

hash
