# shellcheck shell=bash
# Pangeia - application layer: the use cases.
#
# Orchestrates the domain decisions and the adapters. This layer knows
# nothing about command syntax or about how the request was typed.

# Load the adapter file for a manager into the current shell.
pangeia_load_adapter() {
    local file="$PANGEIA_SRC/adapters/$1.sh"

    if [ ! -f "$file" ]; then
        pangeia_err "no adapter for manager '$1'"
        return 1
    fi
    # shellcheck source=/dev/null
    . "$file"
}

# Translate a list of generic names to distro-specific names.
pangeia_resolve_names() {
    local manager="$1"
    shift
    local name out=""

    for name in "$@"; do
        out="$out $(pangeia_package_name "$manager" "$name")"
    done
    printf '%s\n' "${out# }"
}

# Fallback used when the native install fails: try Flatpak before
# giving up. Flatpak app IDs rarely match distro package names, so this
# only helps for apps published under the same name.
pangeia_fallback_flatpak() {
    if ! command -v flatpak >/dev/null 2>&1; then
        pangeia_err "install failed and flatpak is not installed"
        return 1
    fi

    pangeia_warn "native install failed; falling back to flatpak"
    local name rc=0
    for name in "$@"; do
        flatpak install -y --user flathub "$name" || rc=1
    done
    return $rc
}

# Run one use case against the detected (or forced) manager.
pangeia_use() {
    local action="$1"
    shift
    local manager="${PANGEIA_MANAGER:-}"

    [ -n "$manager" ] || manager="$(pangeia_detect_manager)"
    PANGEIA_MANAGER="$manager"
    export PANGEIA_MANAGER

    if [ "$manager" = "unknown" ]; then
        pangeia_err "no supported package manager found"
        return 1
    fi

    pangeia_init_sudo
    pangeia_load_adapter "$manager" || return 1

    local names=""
    case "$action" in
        install)
            names="$(pangeia_resolve_names "$manager" "$@")"
            # shellcheck disable=SC2086  # intentional word splitting of the name list
            if pangeia_adapter_install $names; then
                return 0
            fi
            pangeia_fallback_flatpak "$@"
            ;;
        remove)
            names="$(pangeia_resolve_names "$manager" "$@")"
            # shellcheck disable=SC2086
            pangeia_adapter_remove $names
            ;;
        search)
            pangeia_adapter_search "$@"
            ;;
        update)
            pangeia_adapter_update
            ;;
        *)
            pangeia_err "unknown action: $action"
            return 1
            ;;
    esac
}
