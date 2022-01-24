#!/usr/bin/env bash

# TODO:
# Add common options with flags
# Squash a particular file or directory

# Show backups:
# git show-ref | awk '/ refs.original.refs/{print$2}'
# Remove backups:
# git filter-branch -f \
#     --index-filter 'git rm --cached --ignore-unmatch Rakefile' HEAD
# Alternative solution:
# git update-ref -d refs/original/refs/heads/master

USER="dj-mc"

declare -a repo_list=(
    # "py"
    # "webdev"
    # "node-rw"
)

function decant() {
    for REPO in "${repo_list[@]}"
    do
        # Local mirror of remote repo
        if [ ! -d "${REPO}".git ]; then
            git clone --mirror git@github.com:${USER}/"${REPO}".git
        fi

        if [ ! -d "${REPO}"_backup.git ]; then
            cp -r ./"${REPO}".git ./"${REPO}"_backup.git # Emergency backup
        fi

        git clone "${REPO}".git # Local clone of --mirror
        # Get a list of currently tracked files
        cd "${REPO}" || exit
        git ls-files > /tmp/"${REPO}"-ls.txt
        cd ..; rm -rf "${REPO}"

        cd "${REPO}".git || exit
        # Apply mailmap rules
        git filter-repo --mailmap ~/.keys/.mailmap --force
        # Remove untracked (deleted) files from commmit history
        git filter-repo --paths-from-file /tmp/"${REPO}"-ls.txt
        # Remove empty commits from commit history
        git filter-repo --prune-empty always
        cd ..

        # I have to clone twice because I need `git ls-files` first, and at the
        # same time I may unfortunately only apply this rebase last.
        git clone "${REPO}".git
        # Sign all commits for GitHub's gpg verification
        cd "${REPO}" || exit
        git rebase --exec 'git commit --amend --no-edit -n -S' -i --root
        git push --force # Pushes to local mirror, not remote
        # Manually push to remote (safety reasons)
        cd ..
    done
}

decant
