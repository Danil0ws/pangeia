#!/usr/bin/env bash
# Commands: one canonical name per intent, every spelling mapped to it.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
pangeia_load_all

check_spellings() {
    # $1 = canonical action; every documented spelling must map onto it.
    local action="$1" spelling
    for spelling in $(pangeia_action_spellings "$action"); do
        assert_eq "$action" "$(pangeia_canonical_action "$spelling")" "$action alias $spelling"
    done
}

check_spellings install
check_spellings remove
check_spellings search
check_spellings update
check_spellings list
check_spellings info
check_spellings clean
check_spellings explain
check_spellings detect
check_spellings version
check_spellings help

# Unknown words come back untouched and are not mistaken for actions.
assert_eq frobnicate "$(pangeia_canonical_action frobnicate)" "unknown passthrough"
pangeia_is_action frobnicate
assert_eq 1 "$?" "unknown is not an action"

# A command with no mapping prints the help, and fails.
out="$(PANGEIA_MANAGER=apt pangeia_main verison 2>&1)"
assert_contains "$out" "unknown command 'verison'" "unmapped command is reported"
assert_contains "$out" "Usage:" "unmapped command prints the help"
PANGEIA_MANAGER=apt pangeia_main verison >/dev/null 2>&1
assert_eq 1 "$?" "unmapped command exits 1"

# The commands every manager has reach it in its own syntax.
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 pangeia_main list git 2>/dev/null)"
assert_contains "$out" "dpkg-query -W git" "list on apt"
out="$(PANGEIA_MANAGER=dnf PANGEIA_DRY_RUN=1 pangeia_main installed 2>/dev/null)"
assert_contains "$out" "list installed" "alias installed -> list"
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 pangeia_main show git 2>/dev/null)"
assert_contains "$out" "apt-cache show git" "alias show -> info"
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 pangeia_main autoremove 2>/dev/null)"
assert_contains "$out" "apt-get autoremove -y" "alias autoremove -> clean"

# `info` without a package is an error; `clean` needs none.
PANGEIA_MANAGER=apt pangeia_main info >/dev/null 2>&1
assert_eq 1 "$?" "info without a package exits 1"
PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 pangeia_main clean >/dev/null 2>&1
assert_eq 0 "$?" "clean needs no package"

# `version` asks the manager, and asks it in its own syntax.
out="$(PANGEIA_MANAGER=rpm-ostree PANGEIA_DRY_RUN=1 pangeia_main version 2>/dev/null)"
assert_contains "$out" "rpm-ostree --version" "version on rpm-ostree"
out="$(PANGEIA_MANAGER=pacman PANGEIA_DRY_RUN=1 pangeia_main version 2>/dev/null)"
assert_contains "$out" "pacman -V" "version on pacman"
out="$(PANGEIA_MANAGER=dnf PANGEIA_DRY_RUN=1 pangeia_main version 2>/dev/null)"
assert_contains "$out" "--version" "version on dnf"
out="$(PANGEIA_MANAGER=apt pangeia_main explain version 2>/dev/null)"
assert_contains "$out" "apt-get --version" "explain version"

# The manager's flags are the manager's, not Pangeia's.
out="$(PANGEIA_MANAGER=rpm-ostree PANGEIA_DRY_RUN=1 pangeia_main --version 2>/dev/null)"
assert_contains "$out" "rpm-ostree --version" "--version on rpm-ostree"
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 pangeia_main -v 2>/dev/null)"
assert_contains "$out" "apt-get --version" "-v on apt"
out="$(PANGEIA_MANAGER=apt PANGEIA_DRY_RUN=1 pangeia_main -h 2>/dev/null)"
assert_contains "$out" "apt-get --help" "-h on apt"
out="$(PANGEIA_MANAGER=brew pangeia_main explain --help 2>/dev/null)"
assert_contains "$out" "brew --help" "explain --help"

# Bare `help` is still Pangeia's own.
assert_contains "$(PANGEIA_MANAGER=apt pangeia_main help 2>&1)" "Usage:" "help is Pangeia's"

# explain prints the native command of the detected manager, without
# running it, and accepts the same spellings as the real command.
out="$(PANGEIA_MANAGER=apt pangeia_main explain install ripgrep 2>/dev/null)"
assert_contains "$out" "apt-get install -y ripgrep" "explain apt install"

out="$(PANGEIA_MANAGER=pacman pangeia_main dry-run rm firefox 2>/dev/null)"
assert_contains "$out" "pacman -Rns --noconfirm firefox" "explain translates the spelling"

out="$(PANGEIA_MANAGER=rpm-ostree pangeia_main explain install htop 2>/dev/null)"
assert_contains "$out" "rpm-ostree install htop" "explain rpm-ostree install"

# explain without a command to explain is an error.
PANGEIA_MANAGER=apt pangeia_main explain >/dev/null 2>&1
assert_eq 1 "$?" "explain without a command exits 1"

# The help text documents every canonical action. `native-help` is the
# exception: the user-facing words for it are the flags (-h, --help).
usage="$(pangeia_usage)"
for action in $(pangeia_actions); do
    case "$action" in
        native-help) continue ;;
    esac
    assert_contains "$usage" "$action" "usage documents $action"
done

report "commands"
