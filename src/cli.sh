# shellcheck shell=bash
# Pangeia - presentation layer: the command-line interface.
#
# The only layer allowed to read argv and to print user-facing text.

pangeia_version() {
    if [ -f "$PANGEIA_ROOT/VERSION" ]; then
        cat "$PANGEIA_ROOT/VERSION"
    else
        echo dev
    fi
}

pangeia_usage() {
    cat <<EOF
Pangeia $(pangeia_version) - one command to install packages on any Linux.

Usage:
  pangeia <command> [packages...]

Commands:
  install, i, add        Install one or more packages
  remove, rm, del        Remove one or more packages
  search, find           Search for a package
  update, upgrade, up    Update the system / all packages
  explain, dry-run       Print the native command without running it
  detect, which          Print the detected package manager
  version, -v            Print the version
  help, -h               Print this help

Spellings are interchangeable: 'pangeia get', 'pangeia erase' and
'pangeia lookup' resolve to the standard commands above.

Environment:
  PANGEIA_MANAGER        Force a manager instead of auto-detecting
  PANGEIA_DRY_RUN=1      Print the commands instead of running them

Examples:
  pangeia install git curl vim
  pangeia remove firefox
  pangeia search ripgrep
  pangeia update
  pangeia explain install ripgrep
EOF
}

pangeia_main() {
    if [ "$#" -eq 0 ]; then
        pangeia_usage
        return 1
    fi

    local command="$1"
    shift
    case "$command" in
        help | -h | --help)
            pangeia_usage
            return 0
            ;;
        version | -v | --version)
            pangeia_version
            return 0
            ;;
    esac

    local action
    action="$(pangeia_canonical_action "$command")"

    if ! pangeia_is_action "$action"; then
        local hint
        hint="$(pangeia_suggest_action "$command")"
        if [ -n "$hint" ]; then
            pangeia_err "unknown command '$command'; did you mean '$hint'?"
        else
            pangeia_err "unknown command '$command'; try 'pangeia help'"
        fi
        return 1
    fi

    if [ "$action" = "detect" ]; then
        pangeia_detect_manager
        return 0
    fi

    case "$action" in
        install | remove | search)
            if [ "$#" -eq 0 ]; then
                pangeia_err "'$command' needs at least one package"
                return 1
            fi
            ;;
        explain)
            if [ "$#" -eq 0 ]; then
                pangeia_err "'$command' needs a command: pangeia explain install ripgrep"
                return 1
            fi
            pangeia_explain "$@"
            return $?
            ;;
    esac

    pangeia_use "$action" "$@"
}
