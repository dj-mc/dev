#!/usr/bin/env bash

mkdir ~/.alda/bin
wget -P ~/.alda/bin https://alda-releases.nyc3.digitaloceanspaces.com/2.2.0/client/linux-amd64/alda
wget -P ~/.alda/bin https://alda-releases.nyc3.digitaloceanspaces.com/2.2.0/player/non-windows/alda-player
chmod +x ~/.alda/bin/{alda,alda-player}
