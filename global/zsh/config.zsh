####### helpers for managing configuration files

# reload a specific zsh config file
function reload() {
    local basename file_path config_dir
    basename="$1"
    file_path=""

    for config_dir in $zsh_config_path; do
        if [[ -e "$config_dir/$basename" ]]; then
            file_path="$config_dir/$basename"
            break
        fi
    done

    if [[ -z "$file_path" ]]; then
        echo "File not found in zsh_config_path" >&2
        return 1
    fi

    echo "Reloading $file_path"
    source "$file_path"
}

function _reload() {
    _files -W zsh_config_path
}
compdef _reload reload

# pull config from git repos
() {
    local script_root="$1"
    eval "
        function pull_config() {
            (
                echo
                print -P '%F{green}Pulling main...%f'
                echo

                cd '$script_root'
                rr > /dev/null
                git pull -p

                echo
                print -P '%F{green}Pulling machine...%f'
                echo

                cd machine
                git pull -p

                echo
                print -P '%F{green}Pulling org...%f'
                echo

                cd ../org
                git pull -p

                echo
                print -P '%F{green}Pulling os...%f'
                echo

                cd ../os
                git pull -p
            )
        }

        function push_config() {
            (
                echo
                print -P '%F{green}Pushing main...%f'
                echo

                cd '$script_root'
                rr > /dev/null
                git commit -a -m "Auto-push"
                git push

                echo
                print -P '%F{green}Pushing machine...%f'
                echo

                cd machine
                git commit -a -m "Auto-push"
                git push

                echo
                print -P '%F{green}Pushing org...%f'
                echo

                cd ../org
                git commit -a -m "Auto-push"
                git push

                echo
                print -P '%F{green}Pushing os...%f'
                echo

                cd ../os
                git commit -a -m "Auto-push"
                git push
            )
        }
    "
} "${0:a:h}"
