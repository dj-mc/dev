#!/usr/bin/env bash

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

function if_no_which () {
    if ! [ -x "$(which "$1")" ]; then
        not_found_alert "$1"
        return
    else
        found_alert "$1"
        false
    fi
}
