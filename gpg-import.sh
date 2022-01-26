#!/usr/bin/env bash

ID=$1
FN="$ID".tar.gz

import_key() {
    gpg -o "$FN" -d "$FN".gpg \
        && tar -xzvf "$FN"
    gpg --import "$ID"/"$ID".public.asc
    gpg --import "$ID"/"$ID".private.asc
    gpg --import "$ID"/"$ID".subkey.asc
    gpg --import-ownertrust "$ID"/"$ID".ownertrust.txt
}

import_key

# chmod 600 ~/.gnupg/*
# chmod 700 ~/.gnupg

# gpg --edit-key your@id.here
# gpg> trust
# gpgconf --kill gpg-agent
