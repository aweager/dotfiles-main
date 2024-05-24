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

# Go to the root of the specified repo, or of the one we are in
function rr() {
    if [[ $# -gt 0 ]]; then
        local repo_root result
        for repo_root in "$git_repo_path[$@]"; do
            if [[ -d "$repo_root/$1" ]]; then
                result="$repo_root/$1"
                break
            fi
        done
        if [[ -n "$result" ]]; then
            cd "$result"
        else
            echo "Folder not found in search path git_repo_path" >&2
            return 1
        fi
    elif in_git_repo; then
        cd "$(git_root_dir)"
    else
        echo "Not in a git repo" >&2
        return 1
    fi
    pwd
}

function _rr() {
    _files -W git_repo_path -/
}
compdef _rr rr

# Print github URL for this branch in the repo
function gurl() {
    echo "$(git_repo_url)/tree/$(git_branch_name)"
}

# Print github URL for the pull requests associated with the current branch
function gpurl() {
    echo "$(git_repo_url)/pulls?q=head%3a$(git_branch_name)"
}

# Print URL for a file in the current branch on github
function gfile() {
    local file_path=$(realpath "$1")
    echo "$(git_repo_url)/blob/$(git_branch_name)${file_path##$(git_root_dir)}"
}

# Merge remote branch into current
function gmo() {
    git fetch && git merge "origin/$1" -m "Merge remote branch $1 into $(git_branch_name)"
}
