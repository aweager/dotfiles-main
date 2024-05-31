####### some basic aliases and functions

# ls
alias ls='ls --color=auto -F'
alias la='ls --color=auto -A'
alias ll='ls --color=auto -alF'

# nav
function gd() {
    cd $(dirname "$1")
}
