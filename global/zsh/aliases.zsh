####### some basic aliases and functions

function reload() {
    local basename file_path config_dir
    basename="$1"
    file_path=""

    for config_dir in $zsh_config_path; do
        if [[ -e "$config_dir/$base_name" ]]; then
            file_path="$config_dir/$base_name"
            break
        fi
    done

    if [[ -z "$file_path" ]]; then
        echo "File not found in zsh_config_path" >&2
        return 1
    fi

    source "$file_path"
}

function _reload() {
    _files -W zsh_config_path
}
compdef _reload reload

# ls
alias ls='ls --color'
alias l='ls --color -CF'
alias la='ls --color -A'
alias ll='ls --color -alF'

# nav
function gd() {
    cd $(dirname "$1")
}
