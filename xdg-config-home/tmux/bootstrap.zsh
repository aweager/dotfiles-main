#!/bin/zsh

# Generate and replace root config files:
#     common.tmux.conf
#     tmux.conf
#     vmux.conf
#     mmux.conf

exec {common_fd}>"${0:a:h}/common.tmux.conf"
exec {tmux_fd}>"${0:a:h}/tmux.conf"
exec {vmux_fd}>"${0:a:h}/vmux.conf"
exec {mmux_fd}>"${0:a:h}/mmux.conf"

{
    printf '# %s\n' 'vim: syntax=tmux.conf'
    printf '# Autogenerated by %s\n\n' "${0:a}"
} >&$common_fd >&$tmux_fd >&$vmux_fd >&$mmux_fd

{
    printf 'source-file "%s"\n\n' "${0:a:h}/common.tmux.conf"
} >&$tmux_fd >&$vmux_fd >&$mmux_fd

for dir in "$XDG_CONFIG_HOME" "$xdg_config_dirs[@]"; do
    if [[ -d "$dir/tmux/common.tmux.conf.d" ]]; then
        for file in "$dir/tmux/common.tmux.conf.d"/*.tmux.conf; do
            printf 'source-file "%s"\n' "$file"
        done >&$common_fd
    fi

    if [[ -d "$dir/tmux/tmux.conf.d" ]]; then
        for file in "$dir/tmux/tmux.conf.d"/*.tmux.conf; do
            printf 'source-file "%s"\n' "$file"
        done >&$tmux_fd
    fi

    if [[ -d "$dir/tmux/vmux.conf.d" ]]; then
        for file in "$dir/tmux/vmux.conf.d"/*.tmux.conf; do
            printf 'source-file "%s"\n' "$file"
        done >&$vmux_fd
    fi

    if [[ -d "$dir/tmux/mmux.conf.d" ]]; then
        for file in "$dir/tmux/mmux.conf.d"/*.tmux.conf; do
            printf 'source-file "%s"\n' "$file"
        done >&$mmux_fd
    fi
done

exec {common_fd}>&- {tmux_fd}>&- {vmux_fd}>&- {mmux_fd}>&-
