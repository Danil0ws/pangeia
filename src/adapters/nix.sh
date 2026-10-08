# shellcheck shell=bash
# Adapter: Nix (multi-user or single-user, channel based).
# User-space: never needs root. Package names are resolved against
# nixpkgs, so `pangeia install ripgrep` runs `nix-env -iA nixpkgs.ripgrep`.

pangeia_adapter_update() {
    pangeia_run nix-channel --update
    pangeia_run nix-env -u
}

pangeia_adapter_install() {
    local name args=""
    for name in "$@"; do
        args="$args nixpkgs.$name"
    done
    # shellcheck disable=SC2086  # intentional word splitting of the attribute list
    pangeia_run nix-env -iA $args
}

pangeia_adapter_remove() {
    pangeia_run nix-env -e "$@"
}

pangeia_adapter_search() {
    pangeia_query nix-env -qaP "$@"
}
