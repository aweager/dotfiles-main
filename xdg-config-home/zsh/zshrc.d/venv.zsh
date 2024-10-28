if [[ -e "$HOME/.local/venv${AWE_VENV}/bin/activate" ]]; then
    source "$HOME/.local/venv${AWE_VENV}/bin/activate"
else
    printf 'Python venv not found at %s\n' "~/.local/venv${AWE_VENV}" >&2
fi

dumb clone aweager/command-server &&
    source "$DUMB_CLONE_HOME/command-server/command-server.plugin.zsh"
dumb clone aweager/nix-server &&
    source "$DUMB_CLONE_HOME/nix-server/nix-server.plugin.zsh"
