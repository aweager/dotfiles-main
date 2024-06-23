####### some basic aliases and functions

# ls
alias ls='ls --color=auto -F'
alias la='ls --color=auto -A'
alias ll='ls --color=auto -alF'

# nav
function gd() {
    cd $(dirname "$1")
}

# process hell
zmodload zsh/zutil

function ptable() {
    local -a arg_trunc
    zparseopts -D \
        {t,-truncate}=arg_trunc

    # try to clean up command view
    ps -U "$USER" -o pid -o command | grep "$@" | grep -v grep | awk '
        interpreters["zsh"]=""
        interpreters["bash"]=""
        interpreters["python3"]=""
        interpreters["python3.10"]=""
        interpreters["python3.11"]=""
        interpreters["python3.12"]=""
        interpreters["Python"]=""
        function basename(file, a, n) {
            n = split(file, a, "/")
            return a[n]
        }
        {
            printf "%6s", $1
            $2=basename($2)
            if ($2 in interpreters) {
                $3=basename($3)
                for (i=3; i <= NF; i++) printf " %s", $i
            } else {
                for (i=2; i <= NF; i++) printf " %s", $i
            }
            print ""
        }
    ' | { if [[ -z $arg_trunc ]]; then cat; else cut -c "-$COLUMNS"; fi }
}

function kill-table() {
    awk '{print $1}' | xargs kill "$@"
}
