# shellcheck shell=bash
# Adapter: Gentoo (Portage / emerge).

pangeia_adapter_update() {
    pangeia_run emerge --sync
    pangeia_run emerge -uDN @world
}

pangeia_adapter_install() {
    pangeia_run emerge "$@"
}

pangeia_adapter_remove() {
    pangeia_run emerge --deselect "$@"
}

pangeia_adapter_search() {
    pangeia_query emerge --search "$@"
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query emerge --version
}

pangeia_adapter_list() {
    # qlist ships with portage-utils, alongside emerge.
    pangeia_query qlist -I "$@"
}

pangeia_adapter_info() {
    pangeia_query emerge -pv "$@"
}

pangeia_adapter_clean() {
    pangeia_run emerge --depclean
}
