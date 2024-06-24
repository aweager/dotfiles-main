####### tmux helper functions
autoload -Uz add-zsh-hook


function compdefas() {
    if (($+_comps[$1])); then
        compdef $_comps[$1] ${^@[2,-1]}=$1
    fi
}
compdefas tmux vmux pmux mmux

function start_in_background() {
    tmux -L default has-session -t background > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        tmux -L default new-session -d -s background -n zsh 'zsh'
    fi

    tmux -L default new-window -n "$1" -t background: "$@"
}

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

    if [[ -z "$NVIM_BUFID" ]]; then
        export NVIM_BUFID="$(nvr --remote-expr "luaeval(\"require'init_d.mux'.pid_to_bufnr($$)\")")"
    fi

    function _awe_vim_lcd_hook() {
        nvr -cc ":lua require'init_d.mux'.lcd({
            buffer = $NVIM_BUFID,
            dir = \"$PWD\",
        })" &!
    }
    add-zsh-hook chpwd _awe_vim_lcd_hook
fi

() {
    local -x TMUX="$PMUX"
    local -x TMUX_PANE="$PMUX_PANE"

    source "$XDG_DATA_HOME/tmux/plugins/tmux-mux/shell-hook.sh"

    # TODO move this once pmux is gone
    source "$1/tmp/tmux-hook.zsh"
} "${0:a:h}"

function _awe_tab_rename_preexec_hook() {
    local new_name="$(printf "%.20s" "${1%% *}")"
    rename_window "$new_name" "" italic
}
add-zsh-hook preexec _awe_tab_rename_preexec_hook

function _awe_tab_rename_precmd_hook() {
    rename_window "$(basename "$(print -rP "%~")")"
}
add-zsh-hook precmd _awe_tab_rename_precmd_hook
_awe_tab_rename_precmd_hook
