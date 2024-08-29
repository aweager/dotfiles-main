#!/bin/zsh

dumb clone aweager/jrpc
dumb clone aweager/mux-api
dumb clone aweager/reg-api
dumb clone aweager/tmux-mux
dumb clone aweager/nvim-mux

local -a supported_versions=(3.12 3.11)
local version
for version in "$supported_versions[@]"; do
    if which "python${version}" &> /dev/null; then
        if [[ ! -e "$HOME/.local/venv${version}/bin/activate" ]]; then
            printf 'Making venv for python%s\n' "$version"
            "python${version}" -m venv "$HOME/.local/venv${version}"
        fi

        printf 'Updating deps in venv for python%s\n' "$version"
        source "$HOME/.local/venv${version}/bin/activate"
        pip3 install -q --upgrade pip
        pip3 install -q -r "${0:a:h}/requirements.txt"
        deactivate
    fi
done

for version in "$supported_versions[@]"; do
    if [[ -e "$HOME/.local/venv${version}/bin/activate" ]]; then
        rm "$HOME/.local/venv" &> /dev/null || true
        ln -s "$HOME/.local/venv${version}" "$HOME/.local/venv"
        break
    fi
done

if [[ ! -e "$HOME/.local/venv" ]]; then
    printf 'Python venv missing! Supported versions: %s\n' "$supported_versions" &> /dev/null
fi


if [[ ! -e "$HOME/.local/hg-venv/bin/activate" ]]; then
    printf 'Making venv for hg for python%s\n' "3.10"
    "python3.10" -m venv "$HOME/.local/hg-venv"
fi

printf 'Updating deps in venv for %s\n' "hg"
source "$HOME/.local/hg-venv/bin/activate"
pip3 install -q -r "${0:a:h}/hg-requirements.txt"
deactivate
