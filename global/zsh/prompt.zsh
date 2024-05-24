####### Prompt
autoload -Uz add-zsh-hook

if [[ "$USER" != "$DEFAULT_USER" ]]; then
    export USERNAME_PROMPT="%B%F{9}$USER%F{8}%b@"
else
    export USERNAME_PROMPT=""
fi

if [[ -z "$MACHINE_COLOR" ]]; then
    export MACHINE_COLOR="#14ffff"
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

export PROMPT_TOP_LINE="%b%F{8}[$USERNAME_PROMPT%B%F{$MACHINE_COLOR}$MACHINE_NICKNAME%b%F{8}][$(git_dir_prompt)%b%F{8}] %F{12}[%T]$(git_branch_prompt)"

function __awe_load_prompt() {
    local mode="$1"
    local mode_indicator
    case $mode in
        $ZVM_MODE_INSERT)
            mode_indicator="%b%F{white}(ins)"
            ;;
        $ZVM_MODE_NORMAL)
            mode_indicator="%b%F{red}(nml)"
            ;;
        $ZVM_MODE_VISUAL)
            mode_indicator="%b%F{green}(vis)"
            ;;
        $ZVM_MODE_VISUAL_LINE)
            mode_indicator="%b%F{yellow}(vli)"
            ;;
        $ZVM_MODE_REPLACE)
            mode_indicator="%b%F{cyan}(rep)"
            ;;
    esac

    local newline=$'\n'
    local mode_prefix="$mode_indicator %b%F{white}"
    export PS1="${newline}${PROMPT_TOP_LINE}${newline}${mode_prefix}λ "
    export PS2="${mode_prefix}→     "
}
__awe_load_prompt "$ZVM_MODE_INSERT"

function zvm_after_select_vi_mode() {
    __awe_load_prompt "$ZVM_MODE"
}

function zle-line-init zle-keymap-select {
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
