function git-spatch() {
    git stash save
    git stash pop stash@{1}
    git stash save --patch
    git stash save
    git stash pop stash@{2}
    git stash pop stash@{1}
}

__git_complete g _git
