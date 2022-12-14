#!/usr/bin/env bash

cat /etc/shells
cat /etc/passwd | grep dan

# Invocations
# An interactive shell reads/writes to a user's terminal
# Interactive login shell
cat ~/.profile
cat ~/.bash_logout
cat /etc/profile

# Invoked with `sh`
# Same as above, but without ~/.bash_logout

# Interactive non-login shell
cat ~/.bashrc

# Non-interactive
# All scripts use non-interactive shells
echo $BASH_ENV

# Is it interactive?
echo $-

# POSIX mode
# set -o posix
echo $ENV

# Directory stack
dirs

pushd ~
pushd ..
pushd /etc
dirs

popd ~
dirs
