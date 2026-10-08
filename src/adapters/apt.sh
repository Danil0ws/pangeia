# shellcheck shell=bash
# Adapter: Debian / Ubuntu / Mint / Pop!_OS and derivatives (apt).
# Every adapter implements the same four operations, so the application
# layer never needs to know which system it is talking to.

pangeia_adapter_update() {
    pangeia_run apt-get update
}

pangeia_adapter_install() {
    pangeia_run apt-get install -y "$@"
}

pangeia_adapter_remove() {
    pangeia_run apt-get remove -y "$@"
}

pangeia_adapter_search() {
    pangeia_query apt-cache search "$@"
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query apt-get --version
}
