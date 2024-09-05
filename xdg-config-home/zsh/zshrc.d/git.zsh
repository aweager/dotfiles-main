############# Git repo functions

if [[ -v GIT_REPO_PATH ]]; then
    typeset -T -gx GIT_REPO_PATH git_repo_path
fi

alias gl='git log --oneline --graph'
alias gs='git status'
alias ga='git add --all'
alias gc='git commit -m'
alias gf='git fetch -p'
alias gch='git checkout'
alias gche='git checkout'
alias gb='git checkout -b'
alias gpp='git pull -p'

function gpo() {
    local branch_name=$(git_branch_name)
    git push origin "$branch_name"
    git branch -u "origin/$branch_name" "$branch_name"
}

# Print & copy github URL for this branch in the repo
function gurl() {
    local result="$(git_repo_url)/tree/$(git_branch_name)"
    printf '%s' "$result" | clip copy
    printf 'Copied %s\n' "$result"
}

# Print & copy github URL for the pull requests associated with the current branch
function gpurl() {
    local result="$(git_repo_url)/pulls?q=head%3a$(git_branch_name)"
    printf '%s' "$result" | clip copy
    printf 'Copied %s\n' "$result"
}

# Print & copy URL for a file in the current branch on github
function gfile() {
    local file_path=$(realpath "$1")
    local result="$(git_repo_url)/blob/$(git_branch_name)${file_path##$(git_root_dir)}"
    printf '%s' "$result" | clip copy
    printf 'Copied %s\n' "$result"
}

# Merge remote branch into current
function gmo() {
    git fetch && git merge "origin/$1" -m "Merge remote branch $1 into $(git_branch_name)"
}
