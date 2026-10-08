#!/usr/bin/env bash
# Installer: wires the shell integration once, into a throwaway HOME,
# and links a binary that actually runs. No network: the local checkout
# is installed in place.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
home="$(mktemp -d)"

run_install() {
    HOME="$home" SHELL="${1:-/bin/bash}" PANGEIA_BIN_DIR="$home/bin" \
        bash "$root/install.sh"
}

# --- first run ----------------------------------------------------------
out="$(run_install 2>&1)"
assert_contains "$out" "Done." "installer finishes"
assert_contains "$out" "wired shell integration into $home/.bashrc" "wires bashrc"
assert_contains "$out" "source ~/.bashrc" "says how to load it now"
assert_eq "1" "$(grep -cF "/shell/pangeia.sh" "$home/.bashrc")" "one source line"

assert_file "$home/bin/pangeia" "binary is linked"
assert_contains "$("$home/bin/pangeia" help)" "$(cat "$root/VERSION")" "linked binary runs"

# --- second run is idempotent ------------------------------------------
out="$(run_install 2>&1)"
assert_contains "$out" "already present in $home/.bashrc" "second run says so"
assert_eq "1" "$(grep -cF "/shell/pangeia.sh" "$home/.bashrc")" "still one source line"

# --- a shell that reads neither rc still gets told what to do ----------
out="$(run_install /usr/bin/fish 2>&1)"
assert_contains "$out" "does not read ~/.bashrc or ~/.zshrc" "unknown shell is reported"
assert_contains "$out" "pangeia.sh" "unknown shell gets the line to paste"

rm -rf "$home"
report "install"
