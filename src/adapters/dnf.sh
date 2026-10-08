# shellcheck shell=bash
# Adapter: Fedora / RHEL / CentOS / Rocky / Alma / openSUSE (dnf and yum).
# `yum` is the legacy CLI of dnf, so one adapter serves both.

pangeia_dnf_cli() {
    if command -v dnf >/dev/null 2>&1; then
        echo dnf
    else
        echo yum
    fi
}

pangeia_adapter_update() {
    pangeia_run "$(pangeia_dnf_cli)" upgrade -y
}

pangeia_adapter_install() {
    pangeia_run "$(pangeia_dnf_cli)" install -y "$@"
}

pangeia_adapter_remove() {
    pangeia_run "$(pangeia_dnf_cli)" remove -y "$@"
}

pangeia_adapter_search() {
    "$(pangeia_dnf_cli)" search "$@"
}
