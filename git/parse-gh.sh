#!/usr/bin/env bash

declare -a user_repo

mapfile -t user_repo < <( gh repo list | awk '{ printf $1 "\n" }' )

for EACH in "${user_repo[@]}"
do
    printf "%s\n" "$EACH"
done
