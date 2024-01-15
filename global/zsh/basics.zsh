####### Real basic terminal config

setopt interactivecomments
export LSCOLORS=Exfxcxdxbxegedabagacad

path=("$DEFAULT_USER_HOME/.local/bin" $path)

# vim mode
zplug "jeffreytse/zsh-vi-mode"

function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
}

# each terminal gets its own history
unsetopt share_history

# direnv
eval "$(direnv hook zsh)"
