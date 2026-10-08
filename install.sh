#!/usr/bin/env bash
# Pangeia installer - one line, any Linux, plus macOS.
#
#   curl -fsSL https://raw.githubusercontent.com/Danil0ws/pangeia/main/install.sh | bash
#
# It fetches Pangeia into an XDG data directory, links the `pangeia`
# binary into ~/.local/bin and wires the shell integration into
# ~/.bashrc and ~/.zshrc (idempotent: it never adds the line twice).

set -euo pipefail

PANGEIA_REPO="${PANGEIA_REPO:-https://github.com/Danil0ws/pangeia.git}"
PANGEIA_REF="${PANGEIA_REF:-main}"
PANGEIA_DIR="${PANGEIA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/pangeia}"
PANGEIA_BIN_DIR="${PANGEIA_BIN_DIR:-$HOME/.local/bin}"

say() { printf '%s\n' "$*"; }
fail() {
    printf 'pangeia-install: %s\n' "$*" >&2
    exit 1
}

fetch() {
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
    command -v curl >/dev/null 2>&1 || fail "git or curl is required"
    command -v tar >/dev/null 2>&1 || fail "tar is required"
    say "git not found, downloading tarball instead"
    local tmp
    tmp="$(mktemp -d)"
    curl -fsSL "https://github.com/Danil0ws/pangeia/archive/refs/heads/$PANGEIA_REF.tar.gz" |
        tar -xz -C "$tmp"
    rm -rf "$PANGEIA_DIR"
    mkdir -p "$(dirname "$PANGEIA_DIR")"
    mv "$tmp"/*/ "$PANGEIA_DIR"
    rm -rf "$tmp"
}

wire_shell() {
    local line="[ -f \"$PANGEIA_DIR/shell/pangeia.sh\" ] && . \"$PANGEIA_DIR/shell/pangeia.sh\""
    local rc
    for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
        [ -e "$rc" ] || continue
        if grep -qF "$PANGEIA_DIR/shell/pangeia.sh" "$rc"; then
            continue
        fi
        printf '\n# Pangeia\n%s\n' "$line" >>"$rc"
        say "wired shell integration into $rc"
    done
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
    say "Done. Detected manager: $("$PANGEIA_DIR/bin/pangeia" detect)"
    case ":$PATH:" in
        *":$PANGEIA_BIN_DIR:"*) ;;
        *) say "Add $PANGEIA_BIN_DIR to your PATH to use 'pangeia' directly:" ;;
    esac
    say "Open a new shell, then try: pkg install git"
}

main "$@"
