() {

    local func_name file

    fpath=("$1/fbin" $fpath)
    path=("$1/fbin" $path)

    typeset -U fpath

    for file in "$1/fbin"/*; do
        func_name=$(basename "$file")
        if typeset -f $func_name > /dev/null; then
            unfunction $func_name
        fi
        autoload -Uz $func_name
    done

} "${0:a:h}"
