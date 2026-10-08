# shellcheck shell=bash
# Pangeia - domain: which package manager owns this system?
#
# A pure decision over the environment: it inspects available commands
# and prints the manager id. No side effects, no package operations.
#
# Detection order matters. Atomic/immutable images (rpm-ostree,
# transactional-update) are checked first because they often ship dnf
# or zypper, yet those tools cannot modify the immutable base system.

pangeia_detect_manager() {
    # Tests can point this marker elsewhere instead of touching /run.
    local ostree_marker="${PANGEIA_OSTREE_MARKER:-/run/ostree-booted}"

    if [ -e "$ostree_marker" ] && command -v rpm-ostree >/dev/null 2>&1; then
        echo rpm-ostree
        return 0
    fi
    if command -v transactional-update >/dev/null 2>&1; then
        echo transactional
        return 0
    fi

    if command -v apt-get >/dev/null 2>&1; then
        echo apt
        return 0
    fi
    # `yum` is the legacy CLI of dnf; both are served by the dnf adapter.
    if command -v dnf >/dev/null 2>&1; then
        echo dnf
        return 0
    fi
    if command -v yum >/dev/null 2>&1; then
        echo dnf
        return 0
    fi

    if command -v pacman >/dev/null 2>&1; then
        echo pacman
        return 0
    fi
    if command -v zypper >/dev/null 2>&1; then
        echo zypper
        return 0
    fi
    if command -v apk >/dev/null 2>&1; then
        echo apk
        return 0
    fi
    if command -v xbps-install >/dev/null 2>&1; then
        echo xbps
        return 0
    fi
    if command -v emerge >/dev/null 2>&1; then
        echo emerge
        return 0
    fi

    if command -v nix-env >/dev/null 2>&1; then
        echo nix
        return 0
    fi
    if command -v brew >/dev/null 2>&1; then
        echo brew
        return 0
    fi

    echo unknown
}
