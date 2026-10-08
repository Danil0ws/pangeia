# shellcheck shell=bash
# Adapter: Arch Linux / Manjaro / EndeavourOS and derivatives (pacman).

pangeia_adapter_update() {
    pangeia_run pacman -Syu --noconfirm
}

pangeia_adapter_install() {
    pangeia_run pacman -S --needed --noconfirm "$@"
}

pangeia_adapter_remove() {
    pangeia_run pacman -Rns --noconfirm "$@"
}

pangeia_adapter_search() {
    pangeia_query pacman -Ss "$@"
}

# The manager's own version. `pangeia --version` prints Pangeia's.
pangeia_adapter_version() {
    pangeia_query pacman -V
}
