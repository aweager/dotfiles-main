############# Git repo functions

export git_repo_path=("$DEFAULT_USER_HOME/projects")

alias gl='git log --oneline --graph'
alias gs='git status'
alias ga='git add --all'
alias gc='git commit -m'
alias gf='git fetch'
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
    echo -n "$result" | copy
    echo "Copied $result"
}

# Print & copy github URL for the pull requests associated with the current branch
function gpurl() {
    local result="$(git_repo_url)/pulls?q=head%3a$(git_branch_name)"
    echo -n "$result" | copy
    echo "Copied $result"
}

# Print & copy URL for a file in the current branch on github
function gfile() {
    local file_path=$(realpath "$1")
    local result="$(git_repo_url)/blob/$(git_branch_name)${file_path##$(git_root_dir)}"
    echo -n "$result" | copy
    echo "Copied $result"
}

# Merge remote branch into current
function gmo() {
    git fetch && git merge "origin/$1" -m "Merge remote branch $1 into $(git_branch_name)"
}
