#!/bin/bash
. ./settings.sh

command -v git >/dev/null 2>&1
if [ $? -eq 0 ]; then
    cd "$prefix"
    echo "Updating file list from git repository. Files to be included:"
    echo "---------------------"
    git ls-files | tee "../$manifest"
else
    echo "Unable to find 'git'; cannot update repository."
fi
