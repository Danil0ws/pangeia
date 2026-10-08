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
explain:explain dry-run
detect:detect which
version:version -v --version
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

# Levenshtein distance between two words, two rows at a time.
# ponytail: O(len(a)*len(b)) over words this short is free.
pangeia_edit_distance() {
    local a="$1" b="$2" i j cost up left diag min
    local la=${#a} lb=${#b}
    local -a prev cur

    for ((j = 0; j <= lb; j++)); do
        prev[j]=$j
    done

    for ((i = 1; i <= la; i++)); do
        cur[0]=$i
        for ((j = 1; j <= lb; j++)); do
            if [ "${a:i-1:1}" = "${b:j-1:1}" ]; then
                cost=0
            else
                cost=1
            fi
            up=$((prev[j] + 1))
            left=$((cur[j - 1] + 1))
            diag=$((prev[j - 1] + cost))
            min=$up
            [ "$left" -lt "$min" ] && min=$left
            [ "$diag" -lt "$min" ] && min=$diag
            cur[j]=$min
        done
        prev=("${cur[@]}")
    done

    printf '%s\n' "${prev[lb]}"
}

# The action a mistyped command was probably meant to be; empty when
# nothing is close enough to guess.
pangeia_suggest_action() {
    local word="$1" line spelling action best="" best_d=99 d
    local word_len=${#word}

    while IFS= read -r line; do
        action="${line%%:*}"
        for spelling in ${line#*:}; do
            d="$(pangeia_edit_distance "$word" "$spelling")"
            if [ "$d" -lt "$best_d" ]; then
                best_d="$d"
                best="$action"
            fi
        done
    done < <(_pangeia_action_table)

    # One or two keystrokes off, and not the whole word.
    if [ -n "$best" ] && [ "$best_d" -le 2 ] && [ "$best_d" -lt "$word_len" ]; then
        printf '%s\n' "$best"
    fi
}
