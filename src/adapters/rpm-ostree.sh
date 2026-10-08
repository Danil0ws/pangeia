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
        "$(pangeia_dnf_cli)" search "$@"
    else
        pangeia_warn "no search backend; try: flatpak search $*"
    fi
}
