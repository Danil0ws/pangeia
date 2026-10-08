# shellcheck shell=bash
# Adapter: Void Linux (xbps).

pangeia_adapter_update() {
    pangeia_run xbps-install -Suy
}

pangeia_adapter_install() {
    pangeia_run xbps-install -Sy "$@"
}

pangeia_adapter_remove() {
    pangeia_run xbps-remove -Ry "$@"
}

pangeia_adapter_search() {
    pangeia_query xbps-query -Rs "$@"
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query xbps-install -V
}

pangeia_adapter_list() {
    pangeia_query xbps-query -l "$@"
}

pangeia_adapter_info() {
    pangeia_query xbps-query -RS "$@"
}

pangeia_adapter_clean() {
    pangeia_run xbps-remove -O -y
}
