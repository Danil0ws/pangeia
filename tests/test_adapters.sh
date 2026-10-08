#!/usr/bin/env bash
# Adapters: in dry-run mode each manager must print the right command line.

set -uo pipefail

# shellcheck source=/dev/null
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
pangeia_load_all

PANGEIA_DRY_RUN=1
export PANGEIA_DRY_RUN

check() {
    # $1 = manager, $2 = action, $3 = expected substring, rest = packages
    local manager="$1" action="$2" expected="$3"
    shift 3
    local out
    out="$(PANGEIA_MANAGER="$manager" pangeia_use "$action" "$@")"
    assert_contains "$out" "$expected" "$manager $action"
}

check apt install "apt-get install -y git" git
check dnf install "install -y git" git
check pacman install "pacman -S --needed" git
check zypper install "zypper install -y git" git
check apk install "apk add git" git
check xbps install "xbps-install -Sy git" git
check emerge install "emerge git" git
check rpm-ostree install "rpm-ostree install git" git
check transactional install "pkg install git" git
check nix install "nix-env -iA nixpkgs.git" git
check brew install "brew install git" git

check apt remove "apt-get remove -y git" git
check pacman remove "pacman -Rns" git
check apk remove "apk del git" git
check nix remove "nix-env -e git" git

check apt update "apt-get update"
check pacman update "pacman -Syu"
check brew update "brew update"

# Search is read-only but still honours the dry run, so `pangeia explain`
# can show it instead of running it.
check apt search "apt-cache search git" git
check apt version "apt-get --version"
check dnf version "--version"
check rpm-ostree version "rpm-ostree --version"
check brew version "brew --version"
check nix version "nix-env --version"
check pacman version "pacman -V"

# The commands every manager has, each in its own syntax.
check apt list "dpkg-query -W" git
check dnf list "list installed" git
check pacman list "pacman -Q" git
check zypper list "search --installed-only" git
check apk list "apk info" git
check xbps list "xbps-query -l" git
check emerge list "qlist -I" git
check rpm-ostree list "rpm-ostree status"
check transactional list "rpm -qa" git
check nix list "nix-env -q" git
check brew list "brew list" git

check apt info "apt-cache show git" git
check pacman info "pacman -Si git" git
check nix info "nix-env -qa --description git" git
check brew info "brew info git" git

check apt clean "apt-get autoremove -y"
check dnf clean "autoremove -y"
check pacman clean "pacman -Sc --noconfirm"
check apk clean "apk cache clean"
check xbps clean "xbps-remove -O -y"
check nix clean "nix-collect-garbage -d"
check rpm-ostree clean "rpm-ostree cleanup -m"
check transactional clean "transactional-update cleanup"
check brew clean "brew cleanup"
check pacman search "pacman -Ss git" git
check dnf search "search git" git
check nix search "nix-env -qaP git" git

# Name mapping is applied before the command is built.
out="$(PANGEIA_MANAGER=apt pangeia_use install python-pip)"
assert_contains "$out" "python3-pip" "apt maps python-pip"

out="$(PANGEIA_MANAGER=nix pangeia_use install git curl)"
assert_contains "$out" "nixpkgs.git nixpkgs.curl" "nix prefixes every name"

report "adapters"
