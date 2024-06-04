####### Git info functions

function in_hg_repo() {
    local root="$PWD"
    while [[ -n "$root" && ! -d "$root/.hg" ]]; do
        root="${root%/*}"
    done

    [[ -n "$root" ]]
}

function hg_bookmark_name() {
    hg summary 2> /dev/null | sed -E -n '/^bookmarks: \*([^ ]+).*$/ s//\1/p'
}

function hg_root_dir() {
    local root="$PWD"
    while [[ -n "$root" && ! -d "$root/.hg" ]]; do
        root="${root%/*}"
    done

    if [[ -n "$root" ]]; then
        echo "$root"
    else
        echo "Not in a mercurial repo" >&2
        return 1
    fi
}

function hg_repo_name() {
    basename "$(hg_root_dir)"
}

function hg_path_in_repo() {
    root_dir="$(hg_root_dir)"
    if [[ "$root_dir" == "$PWD" ]]; then
        echo
    else
        echo "${PWD#$root_dir/}"
    fi
}
