####### some basic aliases and functions

# ls
alias ls='ls --color'
alias l='ls --color -CF'
alias la='ls --color -A'
alias ll='ls --color -alF'

# nav
function gd() {
    cd $(dirname "$1")
}
