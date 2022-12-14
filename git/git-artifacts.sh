#!/usr/bin/env bash

git commit --allow-empty -m "Git init"
touch .gitignore .gitattributes README.md
echo "* text=auto" > .gitattributes
git add .gitignore .gitattributes README.md
