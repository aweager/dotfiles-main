####### Git info functions

function in_git_repo() {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

function git_branch_name() {
    git branch --show-current
}

function git_root_dir() {
    git rev-parse --show-toplevel
}

function git_repo_name() {
    basename `git rev-parse --show-toplevel`
}

function git_path_in_repo() {
    path_in_repo=$(git rev-parse --show-prefix)
    echo ${path_in_repo%/}
}

function git_repo_url() {
    if [[ -n "$GITHUB_URL" ]]; then
        echo "${GITHUB_URL}/$(git_repo_name)"
    else
        # Fallback to URL from when we cloned it
        git config --get remote.origin.url
    fi
}
