#!/usr/bin/env bash
# Reads the README language table check: every README is present.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
PANGEIA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check() {
    assert_file "$PANGEIA_ROOT/$1" "$1"
}

for file in README.md README.en.md README.zh-CN.md README.ru.md \
    LICENSE CHANGELOG.md CONTRIBUTING.md CODE_OF_CONDUCT.md VERSION; do
    check "$file"
done

for file in docs/index.md docs/index.en.md docs/index.zh.md docs/index.ru.md \
    docs/usage.md docs/installation.md; do
    check "$file"
done

report "docs"
