#!/usr/bin/env bash
# Pangeia test runner: executes every tests/test_*.sh and aggregates.

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

status=0
for test_file in test_*.sh; do
    printf '== %s\n' "$test_file"
    bash "$test_file" || status=1
done

if [ "$status" -eq 0 ]; then
    printf '\nAll tests passed.\n'
else
    printf '\nTests failed.\n' >&2
fi
exit "$status"
