# shellcheck shell=bash
# Pangeia - shared infrastructure helpers.
#
# Logging and privilege escalation live here so no other layer has to
# know how messages are formatted or how root is obtained.

PANGEIA_SUDO=""

# Print an informational line (stderr, so stdout stays pipe-friendly).
pangeia_info() {
    printf '%s\n' "$*" >&2
}

pangeia_warn() {
    printf 'pangeia: %s\n' "$*" >&2
}

pangeia_err() {
    printf 'pangeia: error: %s\n' "$*" >&2
}

# Resolve how to run privileged commands. User-space managers never
# need escalation, so they are skipped entirely.
pangeia_init_sudo() {
    case "${PANGEIA_MANAGER:-unknown}" in
        nix | brew)
            PANGEIA_SUDO=""
            return 0
            ;;
    esac

    if [ "$(id -u)" -eq 0 ]; then
        PANGEIA_SUDO=""
    elif command -v sudo >/dev/null 2>&1; then
        PANGEIA_SUDO="sudo"
    elif command -v doas >/dev/null 2>&1; then
        PANGEIA_SUDO="doas"
    else
        PANGEIA_SUDO=""
        pangeia_warn "neither sudo nor doas found; running without escalation"
    fi
}

# Run a command with the resolved privilege escalation.
# In dry-run mode the command line is printed instead of executed,
# which is what the automated tests assert against.
pangeia_run() {
    if [ "${PANGEIA_DRY_RUN:-0}" = "1" ]; then
        printf '%s\n' "$*"
        return 0
    fi
    # shellcheck disable=SC2086  # intentional word splitting of $PANGEIA_SUDO
    $PANGEIA_SUDO "$@"
}

# Same contract as pangeia_run, for read-only commands (searches):
# honours PANGEIA_DRY_RUN but never escalates.
pangeia_query() {
    if [ "${PANGEIA_DRY_RUN:-0}" = "1" ]; then
        printf '%s\n' "$*"
        return 0
    fi
    "$@"
}
