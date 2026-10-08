# shellcheck shell=bash
# Pangeia - minimal test harness.
#
# No framework, no dependencies: plain bash. Each test file sources this
# file, calls the assert helpers and the runner reports the tally.
#
# Portable to bash 3.2 (macOS) and zsh is not required.

PANGEIA_TESTS_PASS=0
PANGEIA_TESTS_FAIL=0

# Source every layer, exactly like bin/pangeia does.
pangeia_load_all() {
    PANGEIA_ROOT="${PANGEIA_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
    PANGEIA_SRC="$PANGEIA_ROOT/src"
    export PANGEIA_ROOT PANGEIA_SRC
    # shellcheck source=/dev/null
    . "$PANGEIA_SRC/lib/common.sh"
    # shellcheck source=/dev/null
    . "$PANGEIA_SRC/domain/detect.sh"
    # shellcheck source=/dev/null
    . "$PANGEIA_SRC/domain/mapping.sh"
    # shellcheck source=/dev/null
    . "$PANGEIA_SRC/domain/commands.sh"
    # shellcheck source=/dev/null
    . "$PANGEIA_SRC/application/usecases.sh"
    # shellcheck source=/dev/null
    . "$PANGEIA_SRC/cli.sh"
}

assert_eq() {
    # $1 = expected, $2 = actual, $3 = message
    if [ "$1" = "$2" ]; then
        PANGEIA_TESTS_PASS=$((PANGEIA_TESTS_PASS + 1))
    else
        PANGEIA_TESTS_FAIL=$((PANGEIA_TESTS_FAIL + 1))
        printf 'FAIL: %s\n      expected: %s\n      actual:   %s\n' "$3" "$1" "$2" >&2
    fi
}

assert_contains() {
    # $1 = haystack, $2 = needle, $3 = message
    case "$1" in
        *"$2"*)
            PANGEIA_TESTS_PASS=$((PANGEIA_TESTS_PASS + 1))
            ;;
        *)
            PANGEIA_TESTS_FAIL=$((PANGEIA_TESTS_FAIL + 1))
            printf 'FAIL: %s\n      %s\n      does not contain: %s\n' "$3" "$1" "$2" >&2
            ;;
    esac
}

# Create a throwaway directory holding stub executables, so detection
# and dispatch can be tested on any host.
fake_bin() {
    local dir name
    dir="$(mktemp -d)"
    for name in "$@"; do
        printf '#!/bin/sh\nexit 0\n' >"$dir/$name"
        chmod +x "$dir/$name"
    done
    printf '%s\n' "$dir"
}

assert_file() {
    # $1 = path, $2 = message
    if [ -f "$1" ]; then
        PANGEIA_TESTS_PASS=$((PANGEIA_TESTS_PASS + 1))
    else
        PANGEIA_TESTS_FAIL=$((PANGEIA_TESTS_FAIL + 1))
        printf 'FAIL: %s\n      missing file: %s\n' "$2" "$1" >&2
    fi
}

report() {
    printf '%s: %d passed, %d failed\n' "$1" "$PANGEIA_TESTS_PASS" "$PANGEIA_TESTS_FAIL" >&2
    [ "$PANGEIA_TESTS_FAIL" -eq 0 ]
}
