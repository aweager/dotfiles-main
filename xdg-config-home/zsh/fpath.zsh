#!/bin/zsh
# TODO: get rid of dependencies on this separate from zshrc

fpath=("${0:a:h}/functions" "$fpath[@]")
typeset -U fpath

() {
    local func_name file
    for file in "$1/functions"/*; do
        func_name=$(basename "$file")
        if typeset -f $func_name > /dev/null; then
            unfunction $func_name
        fi
        autoload -Uz $func_name
    done
} "${0:a:h}"
