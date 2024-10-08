####### mux-api and reg-api integration
autoload -Uz add-zsh-hook

function compdefas() {
    if (($+_comps[$1])); then
        compdef $_comps[$1] ${^@[2,-1]}=$1
    fi
}
compdefas tmux vmux mmux

dumb clone aweager/jrpc && \
    source "$DUMB_CLONE_HOME/jrpc/zsh-client/jrpc.plugin.zsh"
dumb clone aweager/jrpc-router && \
    source "$DUMB_CLONE_HOME/jrpc-router/zsh-client/jrpc-router.plugin.zsh"

dumb clone aweager/mux-api && \
    source "$DUMB_CLONE_HOME/mux-api/mux-api.plugin.zsh"
dumb clone aweager/reg-api && \
    source "$DUMB_CLONE_HOME/reg-api/reg-api.plugin.zsh"

dumb clone aweager/tmux-mux && \
    source "$DUMB_CLONE_HOME/tmux-mux/shell-hook.sh"
dumb clone aweager/nvim-mux && \
    source "$DUMB_CLONE_HOME/nvim-mux/shell-hook.sh"

# Start jrpc router and singleton services
# TODO: start in backgrounded tmux session
source "${0:a:h}/singleton-services/start-all"

if [[ -z "$MUX_PROMPT_ICON_COLOR" ]]; then
    export MUX_PROMPT_ICON_COLOR="#88ffff"
fi

if [[ -n "$MUX_INSTANCE" ]]; then
    function _awe_tab_rename_preexec_hook() {
        local new_name="$(printf "%.20s" "${1%% *}")"
        mux -b set-info "$MUX_LOCATION" \
            icon "" \
            icon_color "$MUX_PROMPT_ICON_COLOR" \
            title "$new_name" \
            title_style italic
    }
    add-zsh-hook preexec _awe_tab_rename_preexec_hook

    function _awe_tab_rename_precmd_hook() {
        local new_name="$(basename "$(print -rP "%~")")"
        mux -b set-info "$MUX_LOCATION" \
            icon "" \
            icon_color "$MUX_PROMPT_ICON_COLOR" \
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
