#!/bin/zsh

# Bootstrap $XDG_CONFIG_HOME from this repo and $XDG_CONFIG_DIRS

if ! which stow &> /dev/null; then
    echo "stow is not installed" >&2
    return 1
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
    echo "Must set XDG_CONFIG_HOME before running" >&2
    return 1
fi

printf '%s\n\n' '=== Stowing files in $HOME ==='
stow -t "$HOME" -d "${0:a:h}" --dotfiles --verbose home-stow

echo

printf '%s\n\n' '=== Bootstrapping $XDG_CONFIG_HOME ==='

local -a basenames
for dir in "${0:a:h}/xdg-config-home"/*; do
    basenames+=("$(basename "$dir")")
done

printf '%s ' 'Installing:' "$basenames[@]"
echo; echo

# Splitting out per-directory to get dot-file -> .file conversions at roots,
# and so we can invoke bootstrap.zsh for autogenerated stuff
for basename in "$basenames[@]"; do
    printf '-> Bootstrapping %s\n' "$basename"

    mkdir -p "$XDG_CONFIG_HOME/$basename"
    stow -t "$XDG_CONFIG_HOME/$basename" -d "${0:a:h}/xdg-config-home" --dotfiles --verbose "$basename"

    if [[ -e "$XDG_CONFIG_HOME/$basename/bootstrap.zsh" ]]; then
        printf 'Running script %s\n' "$XDG_CONFIG_HOME/$basename/bootstrap.zsh"
        if "$XDG_CONFIG_HOME/$basename/bootstrap.zsh"; then
        else
            printf '    Error! Exited with code %s\n' $?
        fi
    fi
    echo
done
