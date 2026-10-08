# shellcheck shell=bash
# Pangeia - domain: the command vocabulary.
#
# One canonical name per intent, and every accepted spelling mapped onto
# it. This decouples what the user types from what a given manager calls
# the same thing: `remove` is `uninstall` on rpm-ostree, `del` on apk
# and `-Rns` on pacman. `pangeia explain` shows the native command.
#
# Add a spelling to this table and it works everywhere: normalization,
# the typo suggestions and the tests all read it.

_pangeia_action_table() {
    # canonical:accepted spellings (the first spelling repeats the name)
    cat <<'EOF'
install:install i add get
remove:remove rm del delete uninstall erase
search:search find s lookup
update:update upgrade up refresh
list:list ls installed
info:info show describe
clean:clean cleanup autoremove
explain:explain dry-run
detect:detect which
version:version
help:help -h --help
EOF
}

# Every canonical action name, in help order.
pangeia_actions() {
    local line
    while IFS= read -r line; do
        printf '%s\n' "${line%%:*}"
    done < <(_pangeia_action_table)
}

# The spellings accepted for a canonical action.
pangeia_action_spellings() {
    local line
    while IFS= read -r line; do
        case "$line" in
            "$1":*)
                printf '%s\n' "${line#*:}"
                return 0
                ;;
        esac
    done < <(_pangeia_action_table)
    return 1
}

# Is this word one of the canonical action names?
pangeia_is_action() {
    local action
    for action in $(pangeia_actions); do
        [ "$action" = "$1" ] && return 0
    done
    return 1
}

# Normalize any spelling onto its canonical action. Unknown words are
# handed back untouched, so the caller decides what to do with them.
pangeia_canonical_action() {
    local line spelling
    while IFS= read -r line; do
        for spelling in ${line#*:}; do
            if [ "$spelling" = "$1" ]; then
                printf '%s\n' "${line%%:*}"
                return 0
            fi
        done
    done < <(_pangeia_action_table)
    printf '%s\n' "$1"
}
