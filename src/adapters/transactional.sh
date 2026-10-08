# shellcheck shell=bash
# Adapter: openSUSE MicroOS / Aeon / Kalpa (transactional-update).
# Changes are applied into a new snapshot and need a reboot.

pangeia_adapter_update() {
    pangeia_run transactional-update dup
}

pangeia_adapter_install() {
    pangeia_run transactional-update pkg install "$@" || return 1
    pangeia_warn "staged: reboot to apply"
}

pangeia_adapter_remove() {
    pangeia_run transactional-update pkg remove "$@"
}

pangeia_adapter_search() {
    # transactional-update delegates to zypper for package metadata.
    pangeia_query zypper search "$@"
}
