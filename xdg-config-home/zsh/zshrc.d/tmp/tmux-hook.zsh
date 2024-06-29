if [[ -n "$TMUX" ]]; then
    () {
        if tmux show-option @tmux_finished_loading &> /dev/null; then
            return
        fi

        local loading_options="$(tmux display -p '#{@tmux_loading_options}')"
        local option
        for option in "${(ps|:|)loading_options}"; do
            if [[ -n "$option" ]]; then
                while ! tmux show-option "$option" &> /dev/null; do
                    sleep 0.1
                done
            fi
        done
        tmux set-option @tmux_finished_loading 1

        eval "$(tmux show-environment -s)"
    }
fi
