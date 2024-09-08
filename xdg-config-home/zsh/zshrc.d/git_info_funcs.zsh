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
