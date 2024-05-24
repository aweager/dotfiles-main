####### Prompt
autoload -Uz add-zsh-hook

if [ "$USER" != "$DEFAULT_USER" ]; then
    export USERNAME_PROMPT="%B%F{9}$USER%F{8}%b@"
else
    export USERNAME_PROMPT=""
fi

function git_dir_prompt() {
    if in_git_repo; then
        echo "%b%F{8}$(git_repo_name):%B%F{10}//$(git_path_in_repo)"
    else
        echo "%B%F{10}%~"
    fi
}

function git_branch_prompt() {
    if in_git_repo; then
        echo " %F{13}($(git_branch_name))"
    fi
}

function _awe_prompt_hook() {
    tput el && echo
    print -P "%b%F{8}[$USERNAME_PROMPT$MACHINE_NICKNAME_PROMPT%b%F{8}][$(git_dir_prompt)%b%F{8}] %F{12}[%T]$(git_branch_prompt)"

    export PS1="%b%F{white}(ins) %b%F{white}λ "
    export PS2="%b%F{white}(ins) %b%F{white}→     "
}
add-zsh-hook precmd _awe_prompt_hook

function zvm_after_select_vi_mode() {
    case $ZVM_MODE in
        $ZVM_MODE_NORMAL)
            vi_mode="%b%F{red}(nor)"
            ;;
        $ZVM_MODE_INSERT)
            vi_mode="%b%F{white}(ins)"
            ;;
        $ZVM_MODE_VISUAL)
            vi_mode="%b%F{green}(vis)"
            ;;
        $ZVM_MODE_VISUAL_LINE)
            vi_mode="%b%F{yellow}(vli)"
            ;;
        $ZVM_MODE_REPLACE)
            vi_mode="%b%F{cyan}(rep)"
            ;;
    esac
    export PS1="$vi_mode %b%F{white}λ "
    export PS2="$vi_mode %b%F{white}→     "
}

function zle-line-init zle-keymap-select {
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
