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
