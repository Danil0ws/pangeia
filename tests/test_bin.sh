#!/usr/bin/env bash
# End-to-end: run the real binary. The unit tests source the layers
# themselves, so only this file proves that bin/pangeia wires them all up.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
PANGEIA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$PANGEIA_ROOT/bin/pangeia"

# --- detect and version -------------------------------------------------
assert_eq "ok" "$([ -n "$("$BIN" detect)" ] && echo ok)" "detect prints a manager"
assert_contains "$("$BIN" help)" "$(cat "$PANGEIA_ROOT/VERSION")" "help shows Pangeia's version"

out="$(PANGEIA_MANAGER=pacman PANGEIA_DRY_RUN=1 "$BIN" --version 2>/dev/null)"
assert_contains "$out" "pacman -V" "--version goes to the manager"
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 "$BIN" --help 2>/dev/null)"
assert_contains "$out" "apt-get --help" "--help goes to the manager"

out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 "$BIN" version 2>/dev/null)"
assert_contains "$out" "apt-get --version" "version asks the manager"

# --- an install through the real entry point, in dry-run ----------------
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 "$BIN" install git python-pip 2>/dev/null)"
assert_contains "$out" "apt-get install -y" "bin/pangeia install reaches the adapter"
assert_contains "$out" "python3-pip" "bin/pangeia applies the name mapping"

out="$(PANGEIA_MANAGER=pacman PANGEIA_DRY_RUN=1 "$BIN" remove git 2>/dev/null)"
assert_contains "$out" "pacman -Rns --noconfirm git" "bin/pangeia remove"

out="$(PANGEIA_MANAGER=apk PANGEIA_DRY_RUN=1 "$BIN" update 2>/dev/null)"
assert_contains "$out" "apk update" "bin/pangeia update"

# --- every alias resolves ----------------------------------------------
for alias in i add; do
    out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 "$BIN" "$alias" git 2>/dev/null)"
    assert_contains "$out" "apt-get install -y git" "alias $alias"
done

# --- error paths --------------------------------------------------------
"$BIN" help >/dev/null 2>&1
assert_eq "0" "$?" "help exits 0"

"$BIN" frobnicate >/dev/null 2>&1
assert_eq "1" "$?" "unknown command exits 1"

PANGEIA_MANAGER=bogus "$BIN" install git >/dev/null 2>&1
assert_eq "1" "$?" "unknown manager exits 1"

report "bin"
