# vim mode

function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

    bindkey -M viins "^j" menu-complete
    bindkey -M viins "^k" reverse-menu-complete
}

export ZVM_TERM="xterm-256color"

zinit light jeffreytse/zsh-vi-mode
