############# Git repo functions

if [[ -v GIT_REPO_PATH ]]; then
    typeset -T -gx GIT_REPO_PATH git_repo_path
fi

alias gl='git log --oneline --graph'
alias gs='git status'
alias ga='git add --all'
alias gc='git commit --no-verify -m'
alias gf='git fetch -p'
alias gch='git checkout'
alias gche='git checkout'
alias gb='git checkout -b'
alias gpp='git pull -p'

# Push current branch and make sure upstream is set correctly
function gpo() {
    local branch_name="$(git_branch_name)"
    git push origin "$branch_name" --no-verify
    git branch -u "origin/$branch_name" "$branch_name"
}

# Merge remote branch into current
function gmo() {
    git fetch && git merge "origin/$1" -m "Merge remote branch $1 into $(git_branch_name)"
}

# Print & copy github URL for this branch in the repo
function gurl() {
    local result="$(gh browse -b "$(git_branch_name)" -n)"
    printf '%s' "$result" | clip copy
    printf 'Copied %s\n' "$result"
}

# Print & copy github URL for the pull request associated with the current branch
# Or offer to create one
function gpurl() {
    local result
    if result="$(gh pr view --json url --jq '.url')"; then
        printf '%s' "$result" | clip copy
        printf 'Copied %s\n' "$result"
    else
        printf 'Create a pr for %s in the browser? ' "$(git_branch_name)"
        local choice
        read 'choice?y/n: '
        if [[ "$choice" == y ]]; then
            gh pr create -w
        fi
    fi
}

# Print & copy URL for a file in the current branch on github
function gfile() {
    local result="$(gh browse -b "$(git_branch_name)" -n "$1")"
    printf '%s' "$result" | clip copy
    printf 'Copied %s\n' "$result"
}
