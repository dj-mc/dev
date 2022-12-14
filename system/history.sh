#!/usr/bin/env bash

cp ~/.bash_history ~/.bash_history_$(date +%F)
awk '!seen[$0]++' ~/.bash_history > ~/.seen
rm ~/.bash_history; mv ~/.seen ~/.bash_history
