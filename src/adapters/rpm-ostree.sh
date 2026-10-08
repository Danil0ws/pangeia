# shellcheck shell=bash
# Adapter: Fedora Atomic / Silverblue / Kinoite / Bazzite (rpm-ostree).
# Changes are staged and only take effect after a reboot.

pangeia_adapter_update() {
    pangeia_run rpm-ostree upgrade
}

pangeia_adapter_install() {
    pangeia_run rpm-ostree install "$@" || return 1
    pangeia_warn "staged: reboot to apply (or try: rpm-ostree apply-live)"
}

pangeia_adapter_remove() {
    pangeia_run rpm-ostree uninstall "$@"
}

pangeia_adapter_search() {
    # rpm-ostree has no search; the base image metadata is queryable
    # through dnf, and apps usually live in Flatpak instead.
    if command -v dnf >/dev/null 2>&1 || command -v yum >/dev/null 2>&1; then
        pangeia_query "$(pangeia_dnf_cli)" search "$@"
    else
        pangeia_warn "no search backend; try: flatpak search $*"
    fi
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query rpm-ostree --version
}

# The overlays live in the deployment list; there is nothing to filter.
pangeia_adapter_list() {
    pangeia_query rpm-ostree status
}

pangeia_adapter_info() {
    pangeia_query rpm -qi "$@"
}

pangeia_adapter_clean() {
    pangeia_run rpm-ostree cleanup -m
}

# The manager's own help. `pangeia help` prints Pangeia's.
pangeia_adapter_help() {
    pangeia_query rpm-ostree --help
}
