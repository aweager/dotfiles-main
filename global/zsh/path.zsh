() {

    path=("$DEFAULT_USER_HOME/.local/bin" "$1/bin" $path)

} "${0:a:h}"
