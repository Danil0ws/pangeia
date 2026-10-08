# shellcheck shell=bash
# Pangeia shell integration.
#
# Source this from ~/.bashrc or ~/.zshrc. It defines the `pkg` function
# (with the same behaviour as the `pangeia` binary) plus short aliases,
# so a single command works on any distribution.
#
#   [ -f "$HOME/.local/share/pangeia/shell/pangeia.sh" ] && . "$HOME/.local/share/pangeia/shell/pangeia.sh"

# Locate this file, then the project root (one level up). BASH_SOURCE
# covers bash; zsh falls back to $0, which zsh sets to the sourced file.
_pangeia_self="${BASH_SOURCE[0]:-$0}"
PANGEIA_HOME="$(cd "$(dirname "$_pangeia_self")/.." && pwd)"
export PANGEIA_HOME

pkg() {
    "$PANGEIA_HOME/bin/pangeia" "$@"
}

pangeia() {
    "$PANGEIA_HOME/bin/pangeia" "$@"
}

alias instalar='pkg install'
alias remover='pkg remove'
alias buscar='pkg search'
alias atualizar='pkg update'
