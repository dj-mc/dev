#!/usr/bin/env bash

ID=$1

export_key() {
    gpg --export --armor "$ID" > "$ID".public.asc
    gpg --export-secret-keys --armor "$ID" > "$ID".private.asc
    gpg --export-secret-subkeys --armor "$ID" > "$ID".subkey.asc
    gpg --export-ownertrust > "$ID".ownertrust.txt
}

# export_key

import_key() {
    gpg --import "$ID".public.asc
    gpg --import "$ID".private.asc
    gpg --import "$ID".subkey.asc
    gpg --import-ownertrust "$ID".ownertrust.txt
}

# import_key

# chmod 600 ~/.gnupg/*
# chmod 700 ~/.gnupg

# gpg --edit-key your@id.here
# gpg> trust
# gpgconf --kill gpg-agent
