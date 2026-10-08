#!/usr/bin/env bash
# Pangeia installer - one line, any Linux, plus macOS.
#
#   curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
#   wget -qO- https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
#
# With neither curl nor wget, install one from your own package manager
# (`apt-get install curl`, `apk add curl`, ...) or copy this repository to
# the machine and run ./install.sh from it: a local checkout is installed
# in place, with no download at all.
#
# It fetches Pangeia into an XDG data directory, links the `pangeia`
# binary into ~/.local/bin and wires the shell integration into
# ~/.bashrc and ~/.zshrc (idempotent: it never adds the line twice).

set -euo pipefail

PANGEIA_REPO="${PANGEIA_REPO:-https://github.com/Danil0ws/pangeia.git}"
PANGEIA_REF="${PANGEIA_REF:-main}"
PANGEIA_DIR="${PANGEIA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/pangeia}"
PANGEIA_BIN_DIR="${PANGEIA_BIN_DIR:-$HOME/.local/bin}"

# Where this script sits, when it is run as a file (empty when piped).
_pangeia_self="${BASH_SOURCE[0]:-}"
if [ -n "$_pangeia_self" ] && [ -f "$_pangeia_self" ]; then
    PANGEIA_SELF_DIR="$(cd "$(dirname "$_pangeia_self")" && pwd)"
else
    PANGEIA_SELF_DIR=""
fi

say() { printf '%s\n' "$*"; }
fail() {
    printf 'pangeia-install: %s\n' "$*" >&2
    exit 1
}

# Pipe a tarball from a URL into tar, using whichever downloader exists.
download() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$1" | tar -xz -C "$2"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- "$1" | tar -xz -C "$2"
    else
        fail "none of git, curl and wget is available"
    fi
}

fetch() {
    # Run from a checkout (./install.sh, or a copy on a USB stick):
    # install that directory in place instead of downloading anything.
    if [ -n "$PANGEIA_SELF_DIR" ] && [ -f "$PANGEIA_SELF_DIR/bin/pangeia" ]; then
        PANGEIA_DIR="$PANGEIA_SELF_DIR"
        say "installing from the local checkout at $PANGEIA_DIR"
        return 0
    fi

    if command -v git >/dev/null 2>&1; then
        if [ -d "$PANGEIA_DIR/.git" ]; then
            git -C "$PANGEIA_DIR" fetch --depth 1 origin "$PANGEIA_REF"
            git -C "$PANGEIA_DIR" checkout --quiet FETCH_HEAD
        else
            git clone --depth 1 --branch "$PANGEIA_REF" "$PANGEIA_REPO" "$PANGEIA_DIR"
        fi
        return 0
    fi

    # No git available: fall back to the GitHub source tarball.
    command -v tar >/dev/null 2>&1 || fail "tar is required"
    say "git not found, downloading the tarball instead"
    local tmp
    tmp="$(mktemp -d)"
    download "https://github.com/Danil0ws/pangeia/archive/refs/heads/$PANGEIA_REF.tar.gz" "$tmp"
    rm -rf "$PANGEIA_DIR"
    mkdir -p "$(dirname "$PANGEIA_DIR")"
    mv "$tmp"/*/ "$PANGEIA_DIR"
    rm -rf "$tmp"
}

wire_shell() {
    local line="[ -f \"$PANGEIA_DIR/shell/pangeia.sh\" ] && . \"$PANGEIA_DIR/shell/pangeia.sh\""
    local rc shell_name
    shell_name="$(basename "${SHELL:-bash}")"

    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        # The rc of the shell in use is created if missing; the other
        # shell's rc only matters when that shell was used before.
        if [ ! -e "$rc" ] && [ "$(basename "$rc")" != ".${shell_name}rc" ]; then
            continue
        fi
        if grep -qF "$PANGEIA_DIR/shell/pangeia.sh" "$rc" 2>/dev/null; then
            say "shell integration already present in $rc"
        else
            printf '\n# Pangeia\n%s\n' "$line" >>"$rc"
            say "wired shell integration into $rc"
        fi
    done

    # The current shell only sees `pkg` after it re-reads its rc, so say
    # how. A shell that reads neither file gets the line printed instead
    # of a silent `pkg: command not found`.
    case "$shell_name" in
        bash | zsh) say "Load it now:  source ~/.${shell_name}rc   # or open a new shell" ;;
        *)
            say "note: $shell_name does not read ~/.bashrc or ~/.zshrc"
            say "add this to your shell config: $line"
            ;;
    esac
}

main() {
    say "Pangeia installer"
    fetch
    [ -f "$PANGEIA_DIR/bin/pangeia" ] || fail "download failed, $PANGEIA_DIR/bin/pangeia is missing"

    chmod +x "$PANGEIA_DIR/bin/pangeia" "$PANGEIA_DIR/install.sh"
    mkdir -p "$PANGEIA_BIN_DIR"
    ln -sf "$PANGEIA_DIR/bin/pangeia" "$PANGEIA_BIN_DIR/pangeia"

    wire_shell

    say ""
    local manager
    manager="$("$PANGEIA_DIR/bin/pangeia" detect 2>/dev/null || true)"
    if [ -n "$manager" ]; then
        say "Done. Detected manager: $manager"
    else
        say "Done."
    fi
    case ":$PATH:" in
        *":$PANGEIA_BIN_DIR:"*) ;;
        *) say "Add $PANGEIA_BIN_DIR to your PATH to use 'pangeia' directly." ;;
    esac
    say "Then try: pkg install git"
}

main "$@"
