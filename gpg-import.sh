#!/usr/bin/env bash

ID=$1

import_key() {
    gpg -o "$ID".tar.gz -d "$ID".tar.gz.gpg | tar -xzvf
    gpg --import "$ID".public.asc
    gpg --import "$ID".private.asc
    gpg --import "$ID".subkey.asc
    gpg --import-ownertrust "$ID".ownertrust.txt
}

import_key

# chmod 600 ~/.gnupg/*
# chmod 700 ~/.gnupg

# gpg --edit-key your@id.here
# gpg> trust
# gpgconf --kill gpg-agent
