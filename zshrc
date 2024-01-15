export AWE_CONFIG="${0:a:h}"
zsh_config_path=(
    "$AWE_CONFIG/machine/zsh"
    "$AWE_CONFIG/os/zsh"
    "$AWE_CONFIG/global/zsh"
    "$AWE_CONFIG/org/zsh"
)

() {

    local file config_dir

    for config_dir in "$zsh_config_path[@]"; do
        if [[ -d "$config_dir" ]]; then
            for file in "$config_dir"/*.zsh; do
                source "$file"
            done
        fi
    done

}

zplug load

typeset -U path PATH
