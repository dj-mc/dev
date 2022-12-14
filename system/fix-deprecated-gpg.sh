#!/usr/bin/env bash
# rm -f /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-*.gpg
# deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main

for KEY in $( \
    apt-key list \
    | grep -E "(([ ]{1,2}(([0-9A-F]{4}))){10})" \
    | tr -d " " \
    | grep -E "([0-9A-F]){8}\b" \
); do
    K=${KEY:(-8)}
    apt-key export $K \
    | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/imported-from-trusted-gpg-$K.gpg
done
