#!/usr/bin/env bash

# set -> reset to undo commands
gsettings set org.gnome.Evince allow-links-change-zoom false
gsettings set org.gnome.nautilus.preferences show-hidden-files true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'cycle-windows'

# sudo apt-get install dconf-editor

# Find out which setting you've just changed:

# gsettings list-recursively | sort > before
# gsettings list-recursively | sort > after
# diff before after

# Backup specific settings or all of them:

# dconf dump /org/gnome/ > gnome-settings.txt
# dconf reset -f /org/gnome/
# dconf load /org/gnome/ < gnome-settings.txt

# dconf dump / > dconf-backup.txt
# dconf reset -f /
# dconf load / < dconf-backup.txt
