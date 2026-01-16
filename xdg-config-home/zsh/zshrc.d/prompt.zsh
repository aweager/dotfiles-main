####### Prompt
autoload -Uz add-zsh-hook

if [[ "$USER" != "$DEFAULT_USER" ]]; then
    USERNAME_PROMPT="%B%F{9}$USER%F{8}%b@"
else
    USERNAME_PROMPT=""
fi

if [[ -z "$MACHINE_COLOR" ]]; then
    export MACHINE_COLOR="#14ffff"
fi

function repo_dir_prompt() {
    if in_git_repo; then
        echo "%b%F{8}$(git_repo_name):%B%F{10}//$(git_path_in_repo)"
    elif in_hg_repo; then
        echo "%b%F{8}$(hg_repo_name):%B%F{10}//$(hg_path_in_repo)"
    else
        echo "%B%F{10}%~"
    fi
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable hg git

# Enable checking for bookmarks
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:*:*' use-simple true

# Define the display format: branch name (%b), bookmarks (%m), unstaged indicator (%u), staged indicator (%c)
zstyle ':vcs_info:git:*' formats " %F{13}(%b)%f"
zstyle ':vcs_info:git:*' actionformats ' [%F{yellow}%b|%a%F{default}%u%c]'
zstyle ':vcs_info:hg*:*' formats " %F{13}(%m)%F{8}%f"
zstyle ':vcs_info:hg*:*' actionformats " (%s|%a)[%i%u %b %m]"

function __awe_load_prompt() {
    local mode="$1"
    if [[ -z $mode ]]; then
        vcs_info
        mode="$ZVM_MODE_INSERT"
    fi
    local mode_indicator
    local top_line="%b%F{8}[$USERNAME_PROMPT%B%F{$MACHINE_COLOR}$MACHINE_NICKNAME%b%F{8}][$(repo_dir_prompt)%b%F{8}] %F{12}[%T]${vcs_info_msg_0_}"
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
    local mode_prefix="$mode_indicator %b%f"
    PS1="${newline}${top_line}${newline}${mode_prefix}λ "
    PS2="${mode_prefix}→     "
}
add-zsh-hook precmd __awe_load_prompt

function zvm_after_select_vi_mode() {
    __awe_load_prompt "$ZVM_MODE"
}

function zle-line-init zle-keymap-select {
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
