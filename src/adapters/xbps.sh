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
