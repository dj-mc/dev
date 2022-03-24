#!/usr/bin/env bash

ID=$1

export_key() {
    mkdir -p ./"$ID" || {
        printf "%s" "Cannot mkdir ./$($ID)" >&2
        exit 2
    }
    gpg --export --armor "$ID" > ./"$ID"/"$ID".public.asc
    gpg --export-secret-keys --armor "$ID" > ./"$ID"/"$ID".private.asc
    gpg --export-secret-subkeys --armor "$ID" > ./"$ID"/"$ID".subkey.asc
    gpg --export-ownertrust > ./"$ID"/"$ID".ownertrust.txt
    tar czvf - "$ID" \
        | gpg --symmetric --cipher-algo aes256 -o "$ID".tar.gz.gpg
}

export_key
