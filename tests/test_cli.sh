#!/usr/bin/env bash
# CLI: argument parsing, aliases and error handling.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
pangeia_load_all

assert_eq install "$(pangeia_canonical_action i)" "alias i"
assert_eq install "$(pangeia_canonical_action add)" "alias add"
assert_eq remove "$(pangeia_canonical_action del)" "alias del"
assert_eq search "$(pangeia_canonical_action find)" "alias find"
assert_eq update "$(pangeia_canonical_action upgrade)" "alias upgrade"

version="$(pangeia_version)"
assert_contains "$version" "." "version has a dot"

# PANGEIA_MANAGER forces the adapter even where detection would differ.
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 pangeia_main install git 2>/dev/null)"
assert_contains "$out" "apt-get install -y git" "PANGEIA_MANAGER overrides detection"

# No arguments prints the usage and fails.
pangeia_main >/dev/null 2>&1
assert_eq "1" "$?" "no args exits 1"

# An unknown action must fail.
PANGEIA_MANAGER=apt pangeia_main frobnicate git >/dev/null 2>&1
assert_eq "1" "$?" "unknown action exits 1"

# A known action without packages must fail.
pangeia_main install >/dev/null 2>&1
assert_eq "1" "$?" "install without packages exits 1"

# help must succeed.
pangeia_main help >/dev/null 2>&1
assert_eq "0" "$?" "help exits 0"

report "cli"
