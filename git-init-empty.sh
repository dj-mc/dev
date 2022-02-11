#!/usr/bin/env bash

git checkout --orphan temp_master
git rm -rf .

git commit --allow-empty -m 'Git init'
git rebase --onto temp_master --root main
git branch -D temp_master
