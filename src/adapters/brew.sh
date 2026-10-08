# shellcheck shell=bash
# Adapter: Homebrew on Linux and macOS.
# User-space: never needs root.

pangeia_adapter_update() {
    pangeia_run brew update
    pangeia_run brew upgrade
}

pangeia_adapter_install() {
    pangeia_run brew install "$@"
}

pangeia_adapter_remove() {
    pangeia_run brew uninstall "$@"
}

pangeia_adapter_search() {
    pangeia_query brew search "$@"
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query brew --version
}

pangeia_adapter_list() {
    pangeia_query brew list "$@"
}

pangeia_adapter_info() {
    pangeia_query brew info "$@"
}

pangeia_adapter_clean() {
    pangeia_run brew cleanup
}
