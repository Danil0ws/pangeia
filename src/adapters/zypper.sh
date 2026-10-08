# shellcheck shell=bash
# Adapter: openSUSE Leap / Tumbleweed (zypper).

pangeia_adapter_update() {
    pangeia_run zypper update -y
}

pangeia_adapter_install() {
    pangeia_run zypper install -y "$@"
}

pangeia_adapter_remove() {
    pangeia_run zypper remove -y "$@"
}

pangeia_adapter_search() {
    pangeia_query zypper search "$@"
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query zypper --version
}
