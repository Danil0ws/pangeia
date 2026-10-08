#!/usr/bin/env bash
# Mapping: generic names must resolve to the right distro name.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
pangeia_load_all

assert_eq python3-pip "$(pangeia_package_name apt python-pip)" "apt python-pip"
assert_eq python-pip "$(pangeia_package_name pacman python-pip)" "pacman python-pip"
assert_eq py3-pip "$(pangeia_package_name apk python-pip)" "apk python-pip"
assert_eq apache2 "$(pangeia_package_name apt apache)" "apt apache"
assert_eq httpd "$(pangeia_package_name dnf apache)" "dnf apache"
assert_eq base-devel "$(pangeia_package_name pacman build-tools)" "pacman build-tools"

# Unknown names are a 1:1 mapping.
assert_eq ripgrep "$(pangeia_package_name apt ripgrep)" "apt passthrough"
assert_eq neovim "$(pangeia_package_name apk neovim)" "apk passthrough"

report "mapping"
