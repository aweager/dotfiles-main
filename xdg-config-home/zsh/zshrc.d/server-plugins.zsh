zinit light aweager/command-server
zinit light aweager/reg-api
#zinit light aweager/mux-api
zinit light aweager/nix-server

() {
    local -x PMSPEC=""
    source "$HOME/projects/mux-api/mux-api.plugin.zsh"
}
