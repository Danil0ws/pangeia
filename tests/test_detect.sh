#!/usr/bin/env bash
# Detection: each stub command must resolve to the right manager id.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
pangeia_load_all

expect() {
    # $1 = expected manager, rest = stub commands
    local expected="$1"
    shift
    local dir got
    dir="$(fake_bin "$@")"

    # Isolate PATH to the stubs so the host's real managers are invisible.
    got="$(PATH="$dir" PANGEIA_OSTREE_MARKER=/nonexistent pangeia_detect_manager)"
    rm -rf "$dir"
    assert_eq "$expected" "$got" "detect $expected"
}

expect apt apt-get
expect dnf dnf
expect dnf yum
expect pacman pacman
expect zypper zypper
expect apk apk
expect xbps xbps-install
expect emerge emerge
expect nix nix-env
expect brew brew
expect unknown true

# Atomic images win over the tools they ship with.
dir="$(fake_bin rpm-ostree dnf)"
marker="$(mktemp)"
got="$(PATH="$dir" PANGEIA_OSTREE_MARKER="$marker" pangeia_detect_manager)"
rm -rf "$dir" "$marker"
assert_eq "rpm-ostree" "$got" "detect rpm-ostree over dnf"

dir="$(fake_bin transactional-update zypper)"
got="$(PATH="$dir" PANGEIA_OSTREE_MARKER=/nonexistent pangeia_detect_manager)"
rm -rf "$dir"
assert_eq "transactional" "$got" "detect transactional over zypper"

report "detect"
