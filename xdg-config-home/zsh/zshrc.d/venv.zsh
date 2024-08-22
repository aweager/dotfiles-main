if [[ -e "$HOME/.local/venv${AWE_VENV}/bin/activate" ]]; then
    source "$HOME/.local/venv${AWE_VENV}/bin/activate"
else
    printf 'Python venv not found at %s\n' "~/.local/venv${AWE_VENV}" >&2
fi
