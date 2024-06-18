####### helpers for managing configuration files

# push & pull config from git repos
() {
    local script_root="$1"
    eval "
        function pull-config() {
            local config_dir
            for config_dir in '$script_root' \"\$xdg_config_dirs[@]\"; do
                (
                    cd \"\$config_dir\"
                    if in_git_repo; then
                        rr > /dev/null

                        echo
                        print -P \"%F{green}Pulling \$(git_repo_name)...%f\"
                        echo

                        git pull -p
                    fi
                )
            done
        }

        function push-config() {
            local config_dir
            for config_dir in '$script_root' \"\$xdg_config_dirs[@]\"; do
                (
                    cd \"\$config_dir\"
                    if in_git_repo; then
                        rr > /dev/null

                        echo
                        print -P \"%F{green}Pushing \$(git_repo_name)...%f\"
                        echo

                        git push
                    fi
                )
            done
        }
    "
} "${0:a:h}"
