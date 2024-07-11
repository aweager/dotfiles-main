####### tmux helper functions
autoload -Uz add-zsh-hook

dumb clone aweager/mux-api &&
    source "$DUMB_CLONE_HOME/mux-api/mux-api.plugin.zsh"
dumb clone aweager/reg-api &&
    source "$DUMB_CLONE_HOME/reg-api/reg-api.plugin.zsh"

function compdefas() {
    if (($+_comps[$1])); then
        compdef $_comps[$1] ${^@[2,-1]}=$1
    fi
}
compdefas tmux vmux pmux mmux

typeset -A mux_vars
if [ -z "$USE_NTM" ]; then
    if [ -n "$TMUX" ]; then
        export PMUX="$TMUX"
        export PMUX_PANE="$TMUX_PANE"
    elif [ -n "$VMUX" ]; then
        export PMUX="$VMUX"
        export PMUX_PANE="$VMUX_PANE"
    else
        unset PMUX
        unset PMUX_PANE
    fi
else
    unset PMUX
    unset PMUX_PANE
fi

# TODO move this once pmux is gone
if [[ -n "$PMUX" ]]; then
    () {
        local -x TMUX="$PMUX"
        local -x TMUX_PANE="$PMUX_PANE"

        source "$1/tmp/tmux-hook.zsh"
        source "$DUMB_CLONE_HOME/tmux-mux/shell-hook.sh"
    } "${0:a:h}"
fi

if [[ -n "$NVIM" ]]; then
    source "$DUMB_CLONE_HOME/nvim-mux/shell-hook.sh"
fi

if [[ -n "$MUX_SOCKET" ]]; then
    function _awe_tab_rename_preexec_hook() {
        local new_name="$(printf "%.20s" "${1%% *}")"
        mux -bb set-info "$MUX_LOCATION" \
            icon "" \
            icon_color "white" \
            title "$new_name" \
            title_style italic
    }
    add-zsh-hook preexec _awe_tab_rename_preexec_hook

    function _awe_tab_rename_precmd_hook() {
        local new_name="$(basename "$(print -rP "%~")")"
        mux -bb set-info "$MUX_LOCATION" \
            icon "" \
            icon_color "#55ff55" \
            title "$new_name" \
            title_style default
    }
    add-zsh-hook precmd _awe_tab_rename_precmd_hook
    _awe_tab_rename_precmd_hook

    function _awe_mux_chpwd_hook() {
        printf '%s' "$PWD" | mux -b set-var "$MUX_LOCATION" pwd
    }
    add-zsh-hook chpwd _awe_mux_chpwd_hook
    _awe_mux_chpwd_hook
fi
