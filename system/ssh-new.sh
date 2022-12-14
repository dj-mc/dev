#!/usr/bin/env bash

ssh-keygen -t ed25519 -C "49037253+dj-mc@users.noreply.github.com"
eval "$(ssh-agent -s)"
ssh-add -k ~/.ssh/id_ed25519
