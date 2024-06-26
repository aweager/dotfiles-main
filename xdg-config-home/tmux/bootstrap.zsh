#!/bin/zsh

# TODO: should I go plugin manager?
if [[ ! -d "${XDG_DATA_HOME}/tmux/plugins/tmux-reg/.git" ]]; then
    mkdir -p "${XDG_DATA_HOME}/tmux/plugins"
    git clone git@github.com:aweager/tmux-reg.git "${XDG_DATA_HOME}/tmux/plugins/tmux-reg"
else
    git -C "${XDG_DATA_HOME}/tmux/plugins/tmux-reg" fetch -p
    git -C "${XDG_DATA_HOME}/tmux/plugins/tmux-reg" reset --hard origin/main
fi

if [[ ! -d "${XDG_DATA_HOME}/tmux/plugins/tmux-mux/.git" ]]; then
    mkdir -p "${XDG_DATA_HOME}/tmux/plugins"
    git clone git@github.com:aweager/tmux-mux.git "${XDG_DATA_HOME}/tmux/plugins/tmux-mux"
else
    git -C "${XDG_DATA_HOME}/tmux/plugins/tmux-mux" fetch -p
    git -C "${XDG_DATA_HOME}/tmux/plugins/tmux-mux" reset --hard origin/main
fi

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
